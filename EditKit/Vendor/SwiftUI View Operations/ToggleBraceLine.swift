//
//  SourceEditorCommand.swift
//  SwiftUI Tools
//
//  Created by Dave Carlton on 8/8/21.
//

import XcodeKit

class ToggleBraceLine: XcodeLines {

    override func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) -> Void {
        do {
            try performSetup(invocation: invocation)
            for i in 0 ..< selections.count {
                if let selection = selections[i] as? XCSourceTextRange {
                    // Look at current line for "{", found has matching "}" line
                    let found = hasOpenBrace(index: selection.start.line)
                    if found != 0 {
                        toggleComment(index: selection.start.line)
                        toggleComment(index: found + selection.start.line)
                    }
                }
            }
            completionHandler(nil)
        } catch {
            completionHandler(error as NSError)
        }
    }
}


class RemoveBraceLine: XcodeLines {
    
    override func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) -> Void {
        do {
            try performSetup(invocation: invocation)
            for i in 0 ..< selections.count {
                if let selection = selections[i] as? XCSourceTextRange {
                    // Look at current line for "{", found has matching "}" line
                    let found = hasOpenBrace(index: selection.start.line)
                    if found != 0 {
                        removeLine(index: found + selection.start.line)
                        removeLine(index: selection.start.line)
                    }
                }
            }
            completionHandler(nil)
        } catch {
            completionHandler(error as NSError)
        }
    }
}


