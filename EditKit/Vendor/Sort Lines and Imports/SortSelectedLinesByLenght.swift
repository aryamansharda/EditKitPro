//
//  SortSelectedLinesByLenght.swift
//  Lines Sorter
//
//  Created by aniltaskiran on 24.05.2020.
//  Copyright © 2020 Anıl. All rights reserved.
//

import XcodeKit

class SortSelectedLinesByLength: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        SortSelectedRange().sort(buffer: invocation.buffer, by: .length)
        completionHandler(nil)
    }
}
