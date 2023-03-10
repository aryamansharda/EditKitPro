//
//  SourceEditorCommand.swift
//  SwiftUI Tools
//
//  Created by Dave Carlton on 8/8/21.
//

import XcodeKit

class ToggleBraceLine: XcodeLines {

    override func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: (Error?) -> Void) {
        do {
            try performSetup(invocation: invocation)
            for i in 0 ..< selections.count {
                if i < selections.count, let selection = selections[i] as? XCSourceTextRange {
                    // Look at current line for "{", found has matching "}" line
                    let found = hasOpenBrace(index: selection.start.line)
                    if found != 0 {
                        toggleComment(index: selection.start.line)
                        toggleComment(index: found + selection.start.line)
                    }
                } else {
                    completionHandler(XcodeLinesError.invalidLineSelection.nsError)
                    return
                }
            }

            invocation.buffer.selections.removeAllObjects()
            completionHandler(nil)
        } catch {
            completionHandler(GenericError.default.nsError)
        }
    }
}


class RemoveBraceLine: XcodeLines {
    
    override func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: (Error?) -> Void) {
        do {
            try performSetup(invocation: invocation)
            for i in 0 ..< selections.count {
                if i < selections.count, let selection = selections[i] as? XCSourceTextRange {
                    // Look at current line for "{", found has matching "}" line
                    let found = hasOpenBrace(index: selection.start.line)
                    if found != 0 {
                        removeLine(index: found + selection.start.line)
                        removeLine(index: selection.start.line)
                    }
                } else {
                    completionHandler(XcodeLinesError.invalidLineSelection.nsError)
                    return
                }
            }

            invocation.buffer.selections.removeAllObjects()
            completionHandler(nil)
        } catch {
            completionHandler(GenericError.default.nsError)
        }
    }
}


