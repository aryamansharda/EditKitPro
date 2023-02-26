//
//  WrapInLocalizedString.swift
//  EditKit
//
//  Created by Aryaman Sharda on 1/15/23.
//

import Foundation
import XcodeKit

class WrapInLocalizedStringCommand  {
    static func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: (Error?) -> Void) {
        // Ensure a selection is provided
        guard let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
            completionHandler(GenericError.default.intoNSError)
            return
        }

        // Keep an array of changed line indices.
        var changedLineIndexes = [Int]()

        for lineIndex in selection.start.line...selection.end.line {
            guard let originalLine = invocation.buffer.lines[lineIndex] as? String else {
                continue
            }

            do {
                let regex = try NSRegularExpression(pattern: "\"(.*?)\"")
                let matches = regex.matches(in: originalLine, options: [], range: NSRange(location: 0, length: originalLine.utf16.count))

                var modifiedLine = originalLine
                for match in matches {
                    // Extract the substring matching the capture group
                    if let substringRange = Range(match.range, in: originalLine) {
                        let quotedText = String(originalLine[substringRange])
                        let localizedStringTemplate = "NSLocalizedString(<#T##String#>, value: \(quotedText), comment: \(quotedText))"
                        modifiedLine = modifiedLine.replacingOccurrences(of: quotedText, with: localizedStringTemplate)
                    }
                }

                // Only update lines that have changed.
                if originalLine != modifiedLine {
                    changedLineIndexes.append(lineIndex)
                    invocation.buffer.lines[lineIndex] = modifiedLine
                }
            } catch {
                // Regex was bad!
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
