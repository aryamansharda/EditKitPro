//
//  Sort.swift
//  EditKit
//
//  Created by Aryaman Sharda on 1/19/23.
//

import Foundation
enum Sort {
    case alphabetically
    case length

    func orderStyle(_ lhs: String, _ rhs: String) -> Bool {
        switch self {
        case .alphabetically: return lhs < rhs
        case .length: return lhs.count < rhs.count
        }
    }
}
