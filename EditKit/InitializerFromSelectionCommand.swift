//
//  InitializerFromSelectionCommand.swift
//  EditKit
//
//  Created by Aryaman Sharda on 3/1/23.
//

import Foundation
import XcodeKit

final class InitializerFromSelectionCommand {
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

        var initParameters = [(variableName: String, variableType: String)]()
        for line in selectedLines {
            let trimmedInputLine = line.trimmingCharacters(in: .whitespacesAndNewlines)

            // Skip over empty lines
            guard !trimmedInputLine.isBlank else { continue }
            // Skip over any assignments
            guard !(trimmedInputLine.contains("let ") && trimmedInputLine.contains("=")) else { continue }

            // The delimiter changes depending on whether an assignment occurs or not
            let delimiter: String
            if line.contains("=") && line.contains(":") {
                delimiter = ":"
            } else if line.contains("=") {
                delimiter = "="
            } else {
                delimiter = ":"
            }

            let components = line.components(separatedBy: delimiter)

            // We break the line around the delimiter and grab the first value to the left and right of it
            // Ex. var foo: String would be split into "var foo" and " String"
            // By trimming the whitespace, splitting on the " ", and taking the last and first elements from the resulting arrays,
            // We can easily extract the variable name and type
            if let leadingComponents = components.first?.trimmingCharacters(in: .whitespacesAndNewlines),
               let trailingComponents = components.last?.trimmingCharacters(in: .whitespacesAndNewlines),
               // Find first and last where not empty
               let variableName = leadingComponents.components(separatedBy: " ").last(where: { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }),
               let variableType = trailingComponents.components(separatedBy: " ").first(where: { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) {

                // Removes the force unwrap, if present
                let variableTypeWithoutForcedUnwraps = variableType.replacingOccurrences(of: "!", with: "")
                initParameters.append((variableName: variableName, variableType: variableTypeWithoutForcedUnwraps))
            }
        }

        var body = String()
        var initializerBody = [String]()

        // Creates the body of the initializer with the appropriate padding
        let initBodyPadding = "\t\t"
        for parameter in initParameters {
            body += "\n\(initBodyPadding)self.\(parameter.variableName) = \(parameter.variableName)"
            initializerBody.append("\(parameter.variableName): \(parameter.variableType)")
        }

        // Creates the init's method signature from the list of variables collected ealier
        let padding = "\n\t"
        let initializer = "\(padding)init(\(initializerBody.joined(separator: ", "))) {\(body)\(padding)}"

        // Inserts the new initializer on the line following the last selected line
        invocation.buffer.lines.insert(initializer, at: endIndex + 1)

        completionHandler(nil)
    }
}
