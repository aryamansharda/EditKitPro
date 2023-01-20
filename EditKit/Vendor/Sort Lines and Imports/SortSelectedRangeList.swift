//
//  SortSelectedRangeList.swift
//  Lines Sorter
//
//  Created by aniltaskiran on 24.05.2020.
//  Copyright © 2020 Anıl. All rights reserved.
//

import XcodeKit

struct SortSelectedRange {
    func sort(buffer: XCSourceTextBuffer, by sort: Sort) {
        // At least something is selected
        guard let firstSelection = buffer.selections.firstObject as? XCSourceTextRange,
            let lastSelection = buffer.selections.lastObject as? XCSourceTextRange,
            firstSelection.start.line < lastSelection.end.line else {
                return
        }
        
        let range = (firstSelection.start.line...lastSelection.end.line).saneRange(for: buffer.lines.count)
        let lines = range.compactMap({ buffer.lines[$0] as? String }).sorted(by: sort.orderStyle)

        guard lines.count == range.count else {
            return
        }
        
        let totalLineCount = buffer.lines.count
        range.enumerated().forEach({
            if $1 > totalLineCount { return }
            buffer.lines[$1] = lines[$0]
        })
        let lastSelectedLine = buffer.lines[range.upperBound] as? String
        
        firstSelection.start.column = 0
        lastSelection.end.column = lastSelectedLine?.count ?? 0
    }
}
