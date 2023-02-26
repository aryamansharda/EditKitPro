//
//  StringProtocol+Additions.swift
//  EditKit
//
//  Created by Aryaman Sharda on 2/25/23.
//

import Foundation

extension StringProtocol {
    func distance(of element: Element) -> Int? { firstIndex(of: element)?.distance(in: self) }
    func distance<S: StringProtocol>(of string: S) -> Int? { range(of: string)?.lowerBound.distance(in: self) }
}
