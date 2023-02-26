//
//  Error.swift
//  EditKit
//
//  Created by Aryaman Sharda on 2/25/23.
//

import Foundation

extension Error where Self: LocalizedError {
    var nsError: NSError  {
        let userInfo: [String : Any] = [
            NSLocalizedFailureReasonErrorKey : errorDescription ?? String()
        ]

        return NSError(domain: "EditKit", code: 0, userInfo: userInfo)
    }
}
