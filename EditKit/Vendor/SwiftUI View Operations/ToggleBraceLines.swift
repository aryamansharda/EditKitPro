//
//  ToggleBraceLines.swift
//  SwiftUI Tools
//
//  Created by Dave Carlton on 8/9/21.
//

import Foundation
import XcodeKit
import OSLog

class ToggleBraceLines: XcodeLines {
    
    override func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) -> Void {
        do {
            try performSetup(invocation: invocation)
            for i in 0 ..< selections.count {
                if let selection = selections[i] as? XCSourceTextRange {
                    // Look at current line for "{", found has matching "}" line
                    let found = hasOpenBrace(index: selection.start.line)
                    if found != 0 {
                        for i in selection.start.line ... found + selection.start.line {
                            toggleComment(index: i)
                        }
                    }
                }
            }
            completionHandler(nil)
        } catch {
            completionHandler(error as NSError)
        }
    }
}

class RemoveBraceLines: XcodeLines {
    
    override func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) -> Void {
        do {
            try performSetup(invocation: invocation)
            for i in 0 ..< selections.count {
                if let selection = selections[i] as? XCSourceTextRange {
                    // Look at current line for "{", found has matching "}" line
                    let found = hasOpenBrace(index: selection.start.line)
                    if found != 0 {
                        for i in (selection.start.line ... found + selection.start.line).reversed() {
                            removeLine(index: i)
                        }
                    }
                }
            }
            completionHandler(nil)
        } catch {
            completionHandler(error as NSError)
        }
    }
}
