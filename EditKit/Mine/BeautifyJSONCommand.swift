//
//  BeautifyJSONCommand.swift
//  EditKit
//
//  Created by Aryaman Sharda on 1/16/23.
//

import Foundation
import XcodeKit

class BeautifyJSONCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        guard let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
            // TODO: Update error handling
            completionHandler(NSError(domain: "BeautifyJSON", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid Selection"]))
            return
        }

        let startIndex = selection.start.line
        let endIndex = selection.end.line

        let selectedRange = NSRange(location: startIndex, length: 1 + endIndex - startIndex)

        guard let selectedLines = invocation.buffer.lines.subarray(with: selectedRange) as? [String] else {
            // TODO: Update error handling
            completionHandler(NSError(domain: "BeautifyJSON", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid Selection"]))
            return
        }

        let rawJSON = selectedLines.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)

        guard let beautifiedJSON = rawJSON.data(using: .utf8)?.prettyPrintedJSONString else {
            // TODO: Update error handling
            completionHandler(NSError(domain: "BeautifyJSON", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid Selection"]))
            return
        }

        invocation.buffer.lines.replaceObjects(in: selectedRange, withObjectsFrom: [])
        invocation.buffer.lines.insert(beautifiedJSON, at: startIndex)

        // Set beautified JSON as output
        completionHandler(nil)
    }
}

fileprivate extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
