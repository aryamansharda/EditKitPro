//
//  AlignAroundEqualsCommand.swift
//  EditKit
//
//  Created by Aryaman Sharda on 12/17/22.
//

import Foundation
import XcodeKit

extension StringProtocol {
    func distance(of element: Element) -> Int? { firstIndex(of: element)?.distance(in: self) }
    func distance<S: StringProtocol>(of string: S) -> Int? { range(of: string)?.lowerBound.distance(in: self) }
}

extension Collection {
    func distance(to index: Index) -> Int { distance(from: startIndex, to: index) }
}

extension String.Index {
    func distance<S: StringProtocol>(in string: S) -> Int { string.distance(to: self) }
}

class AlignAroundEqualsCommand {
    static func perform(with invocation: XCSourceEditorCommandInvocation) -> Void {
        // Ensure a selection is provided
        guard let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
            return
        }

        // Keep an array of changed line indices.
        var changedLineIndexes = [Int]()

        // Loop through each line in the buffer and find the furthest out equal sign
        var maximumEqualCharacterIndex = 0
        for lineIndex in selection.start.line...selection.end.line {
            guard let originalLine = invocation.buffer.lines[lineIndex] as? String,
                  let index = originalLine.distance(of: "=") else {
                continue
            }

            maximumEqualCharacterIndex = max(maximumEqualCharacterIndex, index + 1)
        }

        // Loop through all lines, split around equal, and reformat trimming along the way
        for lineIndex in selection.start.line...selection.end.line {

            guard let originalLine = invocation.buffer.lines[lineIndex] as? String else {
                return
            }

            let components = originalLine.components(separatedBy: "=")
            guard components.count == 2 else {
                continue
            }

            var newLine = String()

            // Grab the text to the left of the equals sign and clean it up a bit
            if let lhs = components.first {
                let extraPaddingAmount = maximumEqualCharacterIndex - lhs.count
                newLine = lhs + String(repeating: " ", count: extraPaddingAmount)
                newLine += "= "
            }

            // Grab the text to the right of the equals sign and clean it up a bit
            if let rhs = components.last?.trimmingCharacters(in: .whitespacesAndNewlines) {
                newLine += rhs
            }

            // Only update lines that have changed.
            if originalLine != newLine {
                changedLineIndexes.append(lineIndex)
                invocation.buffer.lines[lineIndex] = newLine
            }
        }

        // Select all lines that were replaced.
        let updatedSelections: [XCSourceTextRange] = changedLineIndexes.map { lineIndex in
            let lineSelection = XCSourceTextRange()
            lineSelection.start = XCSourceTextPosition(line: lineIndex, column: 0)
            lineSelection.end = XCSourceTextPosition(line: lineIndex + 1, column: 0)
            return lineSelection
        }

        // Set selections then return with no error.
        invocation.buffer.selections.setArray(updatedSelections)
    }
}
