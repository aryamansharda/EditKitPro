//
//  XcodeLines.swift
//  SwiftUI Tools
//
//  Created by Dave Carlton on 8/9/21.
//

import Foundation
import XcodeKit
import AppKit
import OSLog

let supportUTIs = [
    "com.apple.dt.playground",
    "public.swift-source",
    "com.apple.dt.playgroundpage"]

class XcodeLines: NSObject, XCSourceEditorCommand {

    enum XcodeLinesError: Error, LocalizedError {
        case incompatibleFileType
        case invalidLineSelection

        var errorDescription: String? {
            switch self {
            case .incompatibleFileType:
                return "Incomaptible file type found (only Swift & Playgrounds supported)."
            case .invalidLineSelection:
                return "Please verify line selections and try again."
            }
        }
    }

    var newLines: [String] = []
    var invocation: XCSourceEditorCommandInvocation?
    var lines: NSMutableArray = []
    var selections: NSMutableArray = []
    var log: Logger = Logger()

    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: (Error?) -> Void) {
        completionHandler(nil)
        return
    }

    func performSetup(invocation: XCSourceEditorCommandInvocation) throws {
        self.invocation = invocation

        let uti = invocation.buffer.contentUTI
                
        guard supportUTIs.contains(uti) else {
            throw XcodeLinesError.incompatibleFileType
        }

        if invocation.buffer.usesTabsForIndentation {
            Indent.char = "\t"
        } else {
            Indent.char = String(repeating: " ", count: invocation.buffer.indentationWidth)
        }
        
        let parser = SwiftParser(string: invocation.buffer.completeBuffer)
        newLines = try parser.format().components(separatedBy: "\n")
        lines = invocation.buffer.lines
        selections = invocation.buffer.selections
    }
    
    func findBalanced(lines: ArraySlice<String>) -> Int {
        var b: Int = 0
        var c: Int = 0
        for line in lines {
            if line.contains("{") { b += 1 }
            if line.contains("}") { b -= 1 }
            if b == 0 {
                return c
            }
            c += 1
        }
        return 0
    }
    
    func updateLine(index: Int) {
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
    
    func toggleComment(index: Int) {
        var newLine:String
        
        guard index < newLines.count, index < lines.count else {
            return
        }
        
        if let line = lines[index] as? String {
            if line.hasPrefix("//") {
                let r = line.range(of: "//")
                newLine = String(line.suffix(from: r!.upperBound))
            } else {
                newLine = "//" + newLines[index] + "\n"
            }
            if newLine != line {
                lines[index] = newLine
            }
        }
    }
    
    func removeLine(index: Int) {
        guard index < newLines.count, index < lines.count else {
            return
        }

        invocation?.buffer.lines.removeObject(at: index)
        
    }
    
    func hasOpenBrace(index: Int) -> Int {
        var found = 0
        let currentLine = newLines[index]
        if currentLine.contains("{") {
            let rangeLines = newLines.suffix(from: index)
            found = findBalanced(lines: rangeLines)
        }
        return found
    }

}
