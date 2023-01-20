//
//  FormatLines.swift
//  SwiftUI Tools
//
//  Created by Dave Carlton on 8/9/21.
//

import XcodeKit
import OSLog

class FormatLines: XcodeLines {

    override func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) -> Void {
        do {
            try performSetup(invocation: invocation)
            var hasSelection = false

            for i in 0 ..< selections.count {
                if let selection = selections[i] as? XCSourceTextRange {
                    hasSelection = true
                    for j in selection.start.line...selection.end.line {
                        updateLine(lines: lines, newLines: newLines, index: j)
                    }
                }
            }
            if !hasSelection {
                for i in 0 ..< lines.count {
                    updateLine(lines: lines, newLines: newLines, index: i)
                }
            }

            completionHandler(nil)
        } catch {
            completionHandler(error as NSError)
        }
    }

    func updateLine(lines: NSMutableArray, newLines: [String], index: Int) {
        guard index < newLines.count, index < lines.count else {
            return
        }
        if let line = lines[index] as? String {
            let newLine = newLines[index] + "\n"
            if newLine != line {
                lines[index] = newLine
            }
        }
    }

}
