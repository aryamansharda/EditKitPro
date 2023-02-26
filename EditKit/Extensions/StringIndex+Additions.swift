//
//  StringIndex+Additions.swift
//  EditKit
//
//  Created by Aryaman Sharda on 2/25/23.
//

import Foundation

extension String.Index {
    func distance<S: StringProtocol>(in string: S) -> Int { string.distance(to: self) }
}
