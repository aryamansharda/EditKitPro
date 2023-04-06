//
//  FormatAsSingleLineCommand.swift
//  EditKit
//
//  Created by Aryaman Sharda on 4/6/23.
//

import Foundation
import XcodeKit

final class FormatAsSingleLineCommand {
    static func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: (Error?) -> Void) {
        // Verifies a selection exists
        guard let selections = invocation.buffer.selections as? [XCSourceTextRange], let selection = selections.first else {
            completionHandler(GenericError.default.nsError)
            return
        }

        let startIndex = selection.start.line
        let endIndex = selection.end.line
        let selectedRange = NSRange(location: startIndex, length: 1 + endIndex - startIndex)

        // Grabs the currently selected lines
        guard let selectedLines = invocation.buffer.lines.subarray(with: selectedRange) as? [String] else {
            completionHandler(GenericError.default.nsError)
            return
        }

        // Flatten into a single string and replace new lines with spaces
        let trimmedInputLines = selectedLines.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

        // Concatenate the lines with a space separator, excluding the first two and last lines
        let compositeLine = trimmedInputLines.enumerated().reduce(into: "") { result, enumeratedLine in
            let (index, line) = enumeratedLine
            let isFirstTwoLines = index < 2
            let isLastLine = index == trimmedInputLines.count - 1

            result += (isFirstTwoLines || isLastLine) ? line : " " + line
        }

        // We want to preserve the leading spacing (indendation), but want to trim the trailing
        let leadingWhitespace = selectedLines.first?.prefix(while: { $0.isWhitespace }) ?? ""

        // Clears out the existing selection
        invocation.buffer.lines.replaceObjects(in: selectedRange, withObjectsFrom: [])

        // And inserts the reformated line at the selection's starting position
        invocation.buffer.lines.insert(leadingWhitespace + compositeLine, at: startIndex)

        completionHandler(nil)
    }

    private static func removeTrailingWhitespace(_ line: String) -> String {
        let leadingWhitespace = line.prefix(while: { $0.isWhitespace })
        let trailingText = line.trimmingCharacters(in: .whitespaces)
        return leadingWhitespace + trailingText
    }
}
