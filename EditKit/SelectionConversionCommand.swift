//
//  SelectionConversionCommand.swift
//  EditKit
//
//  Created by Aryaman Sharda on 3/19/23.
//

import Foundation
import XcodeKit

final class SelectionConversionCommand  {
    enum Operation {
        case lowercase
        case uppercase
        case snakeCase
        case pascalCase
        case camelCase
    }
    
    static func perform(with invocation: XCSourceEditorCommandInvocation, operation: Operation, completionHandler: (Error?) -> Void) {
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

        for (index, selectedLine) in selectedLines.enumerated() {
            var modifiedLine = selectedLine

            let isFirstLineOfSelection = index == 0 && selection.start.column != 0
            let isLastLineOfSelection = index == selectedLines.count - 1 && selection.end.column != 0

            if isFirstLineOfSelection {
                // Handles the case that the first line is a partial selection
                let selectedSubstring = String(selectedLine.dropFirst(selection.start.column))
                let unselectedSubstring = selectedLine.prefix(selection.start.column)

                modifiedLine = String(unselectedSubstring + applyOperation(operation: operation, on: selectedSubstring))

            } else if isLastLineOfSelection {
                // Handles the case that the last line is a partial selection
                let selectedSubstring = String(selectedLine.prefix(selection.end.column))
                let unselectedSubstring = selectedLine.dropFirst(selection.end.column)

                modifiedLine = String(applyOperation(operation: operation, on: selectedSubstring) + unselectedSubstring)

            } else {
                modifiedLine = applyOperation(operation: operation, on: selectedLine)
            }

            invocation.buffer.lines[index + startIndex] = modifiedLine
        }

        completionHandler(nil)
    }

    static func applyOperation(operation: Operation, on input: String) -> String {
        switch operation {
        case .pascalCase:
            return toPascalCase(input)
        case .camelCase:
            return toCamelCase(input)
        case .snakeCase:
            return toSnakeCase(input)
        case .uppercase:
            return input.uppercased()
        case .lowercase:
            return input.lowercased()
        }
    }

    static func toCamelCase(_ input: String) -> String {
        let words = input.components(separatedBy: CharacterSet.alphanumerics.inverted)
        let firstWord = words.first ?? ""
        let camelCaseWords = words.dropFirst().map { $0.capitalized }
        let camelCase = ([firstWord] + camelCaseWords).joined()
        return camelCase.prefix(1).lowercased() + camelCase.dropFirst()
    }

    static func toPascalCase(_ input: String) -> String {
        let words = input.components(separatedBy: CharacterSet.alphanumerics.inverted)
        let pascalCaseWords = words.map { $0.capitalized }
        let pascalCase = pascalCaseWords.joined()
        return pascalCase
    }

    static func toSnakeCase(_ input: String) -> String {
        let words = input.components(separatedBy: CharacterSet.alphanumerics.inverted)
        let snakeCase = words.map { $0.lowercased() }.joined(separator: "_")
        return snakeCase
    }
}
