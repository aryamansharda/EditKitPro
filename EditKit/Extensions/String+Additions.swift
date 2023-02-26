//
//  String+Additions.swift
//  EditKit
//
//  Created by Aryaman Sharda on 2/25/23.
//

import Foundation

extension String {

    func substring(from: Int, to: Int? = nil) -> String {
        let lineLetters = self.map { String($0) }
        let lineLettersSlice = lineLetters[from..<(to ?? count)]
        return lineLettersSlice.joined()
    }
}
