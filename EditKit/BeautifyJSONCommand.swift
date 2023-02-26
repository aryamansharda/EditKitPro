//
//  BeautifyJSONCommand.swift
//  EditKit
//
//  Created by Aryaman Sharda on 1/16/23.
//

import Foundation
import XcodeKit

final class BeautifyJSONCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: (Error?) -> Void) {
        // Checks that a valid selection exists
        guard let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
            completionHandler(NSError(domain: "BeautifyJSON", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid Selection"]))
            return
        }

        let startIndex = selection.start.line
        let endIndex = selection.end.line
        let selectedRange = NSRange(location: startIndex, length: 1 + endIndex - startIndex)

        // Grabs the lines included in the current selection
        guard let selectedLines = invocation.buffer.lines.subarray(with: selectedRange) as? [String] else {
            completionHandler(NSError(domain: "BeautifyJSON", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid Selection"]))
            return
        }

        // Reduces them down into one String with the formatting stripped away
        let rawJSON = selectedLines.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)

        // Converts it to Data and then back to a String to quickly format the JSON
        guard let beautifiedJSON = rawJSON.data(using: .utf8)?.prettyPrintedJSONString else {
            completionHandler(NSError(domain: "BeautifyJSON", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid Selection"]))
            return
        }

        // Clears out the existing selection
        invocation.buffer.lines.replaceObjects(in: selectedRange, withObjectsFrom: [])

        // And inserts the beautified JSON at the line matching the start of the original selection
        invocation.buffer.lines.insert(beautifiedJSON, at: startIndex)

        // Set beautified JSON as output
        completionHandler(nil)
    }
}
