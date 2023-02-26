//
//  AlignAroundEqualsCommand.swift
//  EditKit
//
//  Created by Aryaman Sharda on 12/17/22.
//

import Foundation
import XcodeKit

final class AlignAroundEqualsCommand {
    static func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: (Error?) -> Void) {
        // Ensure a selection is provided
        guard let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
            completionHandler(GenericError.default.nsError)
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

        // Loop through all lines, split around equal, and reformat + trimming along the way
        for lineIndex in selection.start.line...selection.end.line {
            guard let originalLine = invocation.buffer.lines[lineIndex] as? String else {
                // Input was not a String
                completionHandler(GenericError.default.nsError)
                return
            }

            let components = originalLine.components(separatedBy: "=")
            guard components.count == 2 else {
                continue
            }

            var newLine = String()

            // Grab the text to the left of the equals sign and pads it with extra spaces to be
            // in line with the furthest equal sign identified
            if let lhs = components.first {
                let extraPaddingAmount = maximumEqualCharacterIndex - lhs.count
                newLine = lhs + String(repeating: " ", count: extraPaddingAmount)
                newLine += "= "
            }

            // Grab the text to the right of the equals sign and append it
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
        completionHandler(nil)
    }
}
