//
//  WrapInIfDefCommand.swift
//  EditKit
//
//  Created by Aryaman Sharda on 12/17/22.
//

import Foundation
import XcodeKit

final class WrapInIfDefCommand {
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
        let selectedLines = invocation.buffer.lines.subarray(with: selectedRange)

        // Wraps the selection in an #ifdef and uses the selection for both parts of the conditional body
        invocation.buffer.lines.insert("#if swift(>=5.5)", at: startIndex)

        for string in selectedLines.reversed() {
            invocation.buffer.lines.insert(string, at: startIndex + 1)
        }

        invocation.buffer.lines.insert("#else", at: startIndex + selectedLines.count + 1)
        invocation.buffer.lines.insert("#endif", at: endIndex + selectedLines.count + 3)

        completionHandler(nil)
    }
}
