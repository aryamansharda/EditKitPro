//
//  AutoCreateExtensionMarks.swift
//  EditKit
//
//  Created by Aryaman Sharda on 12/17/22.
//

import Foundation
import XcodeKit

class AutoCreateExtensionMarksCommand {

    // TODO: Needs work - doesn't handle extisting MARK and the extensionName is wrong

    static func perform(with invocation: XCSourceEditorCommandInvocation) -> Void {

        let sourceLines = invocation.buffer.lines
        var newLines = [Any]()
        sourceLines.forEach({ line in
            if let stringLine = line as? String {
                if stringLine.contains("extension") {
                    let components = stringLine.split(separator: ":")
                    if let lastComponent = components.last {
                        let extensionName = lastComponent.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: " ", with: "")
                        let markLine = "// MARK: - \(extensionName)"
                        if !(sourceLines.compactMap { $0 as? String }).contains(markLine) {
                            newLines.append("\(markLine)\n")
                        }
                    }
                }
            }
            newLines.append(line)
        })

        sourceLines.removeAllObjects()
        sourceLines.addObjects(from: newLines)
    }
}
