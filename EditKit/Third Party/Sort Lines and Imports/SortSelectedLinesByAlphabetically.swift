//
//  SortSelectedLinesByAlphabetically.swift
//  Lines Sorter
//
//  Created by aniltaskiran on 24.05.2020.
//  Copyright © 2020 Anıl. All rights reserved.
//

import XcodeKit

class SortSelectedLinesByAlphabeticallyAscending: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: (Error?) -> Void) {
        SortSelectedRange().sort(buffer: invocation.buffer, by: .alphabeticallyAscending, completionHandler: completionHandler)
    }
}

class SortSelectedLinesByAlphabeticallyDescending: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: (Error?) -> Void) {
        SortSelectedRange().sort(buffer: invocation.buffer, by: .alphabeticallyDescending, completionHandler: completionHandler)
    }
}
