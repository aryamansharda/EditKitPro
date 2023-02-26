//
//  XCSourceTextBuffer+Additions.swift
//  EditKit
//
//  Created by Aryaman Sharda on 2/25/23.
//

import Foundation
import XcodeKit

extension XCSourceTextBuffer {
    func substring(by index: Int, from: Int, to: Int? = nil) -> String {
        var index = index
        if index == lines.count {
            index -= 1
        }
        let line = lines[index] as! String
        return line.substring(from: from, to: to)
    }
}
