//
//  SortSelectedRangeList.swift
//  Lines Sorter
//
//  Created by aniltaskiran on 24.05.2020.
//  Copyright © 2020 Anıl. All rights reserved.
//

import XcodeKit

struct SortSelectedRange {
    enum SortSelectedRangeError: Error, LocalizedError {
        case genericError

        var errorDescription: String? {
            return "Please verify your selection and try again."
        }
    }

    func sort(buffer: XCSourceTextBuffer, by sort: Sort, completionHandler: (Error?) -> Void) {
        // At least something is selected
        guard let firstSelection = buffer.selections.firstObject as? XCSourceTextRange,
            let lastSelection = buffer.selections.lastObject as? XCSourceTextRange,
            firstSelection.start.line < lastSelection.end.line else {
            completionHandler(SortSelectedRangeError.genericError.nsError)
            return
        }
        
        let range = (firstSelection.start.line...lastSelection.end.line).saneRange(for: buffer.lines.count)
        var lines = range.compactMap({ buffer.lines[$0] as? String }).sorted(by: sort.orderStyle)

        // Handles the situation where the user is sorting elements of a list
        var commaCount = 0

        // If the number of trailing commas is one less than the number of lines, then we are looking
        // at a selection of array elements
        lines.forEach { if $0.trimmingCharacters(in: .newlines).last == "," { commaCount += 1 }}
        let selectionIsList = commaCount == lines.count - 1

        // If we're in an array, ensure all rows, but the last have a trailing comma
        if selectionIsList {
            lines = lines.map {
                if let lastCharacter = $0.trimmingCharacters(in: .newlines).last, lastCharacter == "," {
                    return $0
                } else {
                    return $0.trimmingCharacters(in: .newlines) + ","
                }
            }

            if let lastLine = lines.last, lastLine.trimmingCharacters(in: .newlines).last == "," {
                lines[lines.count - 1] = String(lastLine.trimmingCharacters(in: .newlines).dropLast(1))
            }
        }

        guard lines.count == range.count else {
            completionHandler(SortSelectedRangeError.genericError.nsError)
            return
        }
        
        let totalLineCount = buffer.lines.count
        range.enumerated().forEach {
            if $1 > totalLineCount { return }
            buffer.lines[$1] = lines[$0]
        }

        let lastSelectedLine = buffer.lines[range.upperBound] as? String
        firstSelection.start.column = 0
        lastSelection.end.column = lastSelectedLine?.count ?? 0

        EditorHelper.setCursor(atLine: lastSelection.end.line, column: lastSelection.end.column, buffer: buffer)
        completionHandler(nil)
    }
}
