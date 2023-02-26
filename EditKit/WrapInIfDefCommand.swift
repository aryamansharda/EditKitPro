//
//  WrapInIfDefCommand.swift
//  EditKit
//
//  Created by Aryaman Sharda on 12/17/22.
//

import Foundation
import XcodeKit

class WrapInIfDefCommand {
    static func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: (Error?) -> Void) {
        guard let selections = invocation.buffer.selections as? [XCSourceTextRange], let selection = selections.first else {
            completionHandler(GenericError.default.nsError)
            return
        }

        let startIndex = selection.start.line
        let endIndex = selection.end.line
        let selectedRange = NSRange(location: startIndex, length: 1 + endIndex - startIndex)
        let selectedLines = invocation.buffer.lines.subarray(with: selectedRange)

        invocation.buffer.lines.insert("#if swift(>=5.5)", at: startIndex)

        for string in selectedLines.reversed() {
            invocation.buffer.lines.insert(string, at: startIndex + 1)
        }

        invocation.buffer.lines.insert("#else", at: startIndex + selectedLines.count + 1)
        invocation.buffer.lines.insert("#endif", at: endIndex + selectedLines.count + 3)

        completionHandler(nil)
    }
}
