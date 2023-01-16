//
//  FormatCodeForSharing.swift
//  EditKit
//
//  Created by Aryaman Sharda on 12/17/22.
//

import Foundation
import XcodeKit
import AppKit


class FormatCodeForSharingCommand {

    static func perform(with invocation: XCSourceEditorCommandInvocation) -> Void {
        let selectedText = selectedText(from: invocation.buffer)
        
        if !selectedText.isEmpty {
            let pasteboardString = "```\n\(selectedText)\n```"

            let pasteboard = NSPasteboard.general
            pasteboard.declareTypes([.string], owner: nil)
            pasteboard.setString(pasteboardString, forType: .string)
        }
    }

    private static func selectedText(from buffer: XCSourceTextBuffer) -> String {
        var text = ""

        for (index, selection) in buffer.selections.enumerated() {
            if index > 0 {
                text.append("\n")
            }
            let range = selection as! XCSourceTextRange

            if range.start.line == range.end.line {
                let line = buffer.substring(by: range.start.line, from: range.start.column, to: range.end.column)
                text.append(line)
                continue
            }

            let firstLine = buffer.substring(by: range.start.line, from: range.start.column)
            text.append(firstLine)

            if range.end.line - range.start.line > 1 {
                for line in (range.start.line+1)...(range.end.line-1) {
                    let line = buffer.lines[line] as! String
                    text.append(line)
                }
            }

            let lastLine = buffer.substring(by: range.end.line, from: 0, to: range.end.column)
            text.append(lastLine)
        }

        text = text.trimmingCharacters(in: CharacterSet(charactersIn: "\n"))

        var minSpaceCount = Int.max
        var array = text.components(separatedBy: "\n")
        array.forEach { text in
            let count = text.beginingSpaceCount()
            if minSpaceCount > count {
                minSpaceCount = count
            }
        }

        array = array.map { text in
            text.trimming(by: minSpaceCount)
        }

        return array.joined(separator: "\n")
    }
}

fileprivate extension String {

    func beginingSpaceCount() -> Int {
        var count = 0
        for character in self {
            guard String(character) == " " else {
                break
            }
            count += 1
        }
        return count
    }

    func trimming(by count: Int) -> String {
        return substring(from: count)
    }

    func substring(from: Int, to: Int? = nil) -> String {
        let lineLetters = self.map { String($0) }
        let lineLettersSlice = lineLetters[from..<(to ?? count)]
        return lineLettersSlice.joined()
    }
}

fileprivate extension XCSourceTextBuffer {

    func substring(by index: Int, from: Int, to: Int? = nil) -> String {
        var index = index
        if index == lines.count {
            index -= 1
        }
        let line = lines[index] as! String
        return line.substring(from: from, to: to)
    }
}
