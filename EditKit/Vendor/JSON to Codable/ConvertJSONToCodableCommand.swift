//
//  SourceEditorCommand.swift
//  Json2SwiftExtension
//
//  Created by Husnain Ali on 23/02/22.
//

import Foundation
import XcodeKit
import AppKit

class ConvertJSONToCodableCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) -> Void {
        guard let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
            completionHandler(NSError.invalidSelection)
            return
        }

        guard let copiedString = NSPasteboard.general.pasteboardItems?.first?.string(forType: .string) else {
            completionHandler(NSError.emptyClipboard)
            return
        }

        guard let data = copiedString.data(using: .utf8),
              let jsonArray = data.serialized() else {
            completionHandler(NSError.malformedJSON)
            return
        }

        Tree.build(.swift, name: String(placeholder: "Root"),from: jsonArray)
        invocation.buffer.lines.insert(Tree.write(), at: selection.start.line)

        completionHandler(nil)
    }
}

extension NSError {
    static var emptyClipboard: NSError {
        NSError(
            domain: "",
            code: 1,
            userInfo: failureReasonInfo(
                title: "Empty Clipboard",
                message: "The clipboard appears empty."
            )
        )
    }

    static var invalidSelection: NSError {
        NSError(
            domain: "",
            code: 1,
            userInfo: failureReasonInfo(
                title: "Selection Invalid",
                message: "The selection is invalid."
            )
        )
    }

    static var malformedJSON: NSError {
        NSError(
            domain: "",
            code: 1,
            userInfo: failureReasonInfo(
                title: "Malformed JSON",
                message: "The copied JSON appears malformed."
            )
        )
    }
}

private extension NSError {
    static func failureReasonInfo(title: String, message: String, comment: String = "") -> [String: Any] {
        [
            NSLocalizedFailureReasonErrorKey: NSLocalizedString(
                title,
                value: message,
                comment: comment
            )
        ]
    }
}
