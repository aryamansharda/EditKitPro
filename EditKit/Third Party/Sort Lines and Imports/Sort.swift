//
//  Sort.swift
//  EditKit
//
//  Created by Aryaman Sharda on 1/19/23.
//

import Foundation
enum Sort {
    case alphabeticallyAscending
    case alphabeticallyDescending
    case length

    func orderStyle(_ lhs: String, _ rhs: String) -> Bool {
        switch self {
        case .alphabeticallyAscending: return lhs < rhs
        case .alphabeticallyDescending: return lhs > rhs
        case .length: return lhs.count < rhs.count
        }
    }
}
