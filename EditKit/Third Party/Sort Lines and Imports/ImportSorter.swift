//
//  SourceEditorCommand.swift
//  SorterExtension
//
//  Created by aniltaskiran on 24.05.2020.
//  Copyright © 2020 Anıl. All rights reserved.
//

import Foundation
import XcodeKit

class ImportSorter: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: (Error?) -> Void) {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        let bridgedLines = invocation.buffer.lines.compactMap { $0 as? String }
            
        let importFrameworks = bridgedLines.enumerated().compactMap({
            $0.element.isImportLine ? $0.element.removeImportPrefix.removeNewLine : nil
        }).sorted()
        
        let importIndex = bridgedLines.enumerated().compactMap({
            return $0.element.isImportLine ? $0.offset : nil
        }).sorted()
        
        guard importIndex.count == importFrameworks.count && invocation.buffer.lines.count > importIndex.count else {
            completionHandler(GenericError.default.nsError)
            return
        }

        importFrameworks.enumerated().forEach({ invocation.buffer.lines[importIndex[$0]] = "import \($1)" })
        completionHandler(nil)
    }
}

struct Line: Comparable {
    static func < (lhs: Line, rhs: Line) -> Bool {
        lhs.element < rhs.element
    }
    
    let index: Int
    let element: String
}
