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

            let isFirstLineOfSelection = index == 0 //&& selection.start.column != 0
            let isLastLineOfSelection = index == selectedLines.count - 1 //&& selection.end.column != 0

            if isFirstLineOfSelection && isLastLineOfSelection {
                let endOfSelection = selectedLine.prefix(selection.end.column)
                let trailingUnselected = selectedLine.suffix(from: selectedLine.index(selectedLine.startIndex, offsetBy: selection.end.column))

                let leadingUnselected = selectedLine.prefix(selection.start.column)
                let transformedSelection = applyOperation(operation: operation, on: String(endOfSelection.dropFirst(selection.start.column)))

                modifiedLine = leadingUnselected + transformedSelection + trailingUnselected

            } else if isFirstLineOfSelection {
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

    // Courtesy of ChatGPT :)
    static func toCamelCase(_ input: String) -> String {
        let words = input.components(separatedBy: CharacterSet.alphanumerics.inverted)
        let firstWord = words.first ?? ""
        let camelCaseWords = words.dropFirst().map { $0.capitalized }
        let camelCase = ([firstWord] + camelCaseWords).joined()
        return camelCase.prefix(1).lowercased() + camelCase.dropFirst()
    }

    static func toPascalCase(_ input: String) -> String {
        let words = input.components(separatedBy: CharacterSet.alphanumerics.inverted)
        let pascalCaseWords = words.map { word -> String in
            guard !word.isEmpty else { return "" }
            let firstChar = String(word.prefix(1)).capitalized
            let remainingChars = String(word.dropFirst())
            return firstChar + remainingChars
        }
        let pascalCase = pascalCaseWords.joined()
        return pascalCase
    }

    static func toSnakeCase(_ inputString: String) -> String {
        var result = ""
        var isBeginningOfWord = true

        for character in inputString {
            if character.isLetter || character.isNumber {
                if character.isUppercase {
                    if !isBeginningOfWord {
                        result.append("_")
                    }
                    result.append(String(character).lowercased())
                } else {
                    result.append(character)
                }
                isBeginningOfWord = false
            } else {
                if !isBeginningOfWord {
                    result.append("_")
                }
                isBeginningOfWord = true
            }
        }

        // Remove trailing underscore, if any
        if result.last == "_" {
            result.removeLast()
        }

        return result
    }
}
