//
//  SortSelectedLinesByLenght.swift
//  Lines Sorter
//
//  Created by aniltaskiran on 24.05.2020.
//  Copyright © 2020 Anıl. All rights reserved.
//

import XcodeKit

class SortSelectedLinesByLength {
    static func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: (Error?) -> Void) {
        SortSelectedRange().sort(buffer: invocation.buffer, by: .length, completionHandler: completionHandler)
    }
}
