//
//  SortSelectedLinesByAlphabetically.swift
//  Lines Sorter
//
//  Created by aniltaskiran on 24.05.2020.
//  Copyright © 2020 Anıl. All rights reserved.
//

import XcodeKit

class SortSelectedLinesByAlphabetically: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        SortSelectedRange().sort(buffer: invocation.buffer, by: .alphabetically)
        completionHandler(nil)
    }
}
