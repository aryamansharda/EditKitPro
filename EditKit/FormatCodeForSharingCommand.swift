//
//  FormatCodeForSharing.swift
//  EditKit
//
//  Created by Aryaman Sharda on 12/17/22.
//

import Foundation
import XcodeKit
import AppKit

final class FormatCodeForSharingCommand {
    static func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: (Error?) -> Void) {
        guard let selections = invocation.buffer.selections as? [XCSourceTextRange], let selection = selections.first else {
            completionHandler(GenericError.default.nsError)
            return
        }

        let startIndex = selection.start.line
        let endIndex = selection.end.line
        let selectedRange = NSRange(location: startIndex, length: 1 + endIndex - startIndex)

        // Grabs the lines included in the current selection
        guard let selectedLines = invocation.buffer.lines.subarray(with: selectedRange) as? [String] else {
            completionHandler(GenericError.default.nsError)
            return
        }

        // Reduces them down into one String with the formatting stripped away
        let text = selectedLines.joined()
        let pasteboardString = "```\n\(text)```"
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(pasteboardString, forType: .string)

        completionHandler(nil)
    }
}
