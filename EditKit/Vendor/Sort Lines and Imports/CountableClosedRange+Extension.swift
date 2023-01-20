//
//  CountableClosedRange+Extension.swift
//  Lazy Xcode
//
//  Created by aniltaskiran on 26.05.2020.
//  Copyright © 2020 Anıl. All rights reserved.
//

import Foundation

extension CountableClosedRange where Bound == Int {    
    func saneRange(for elementsCount: Int) -> CountableClosedRange<Bound> {
        let lowerBound = Swift.max(self.lowerBound, 0)
        let upperBound = Swift.min(self.upperBound, Swift.max(0, elementsCount - 1))
        return lowerBound...upperBound
    }
    
    func omittingFirstAndLastNewLine(in lines: NSMutableArray) -> CountableClosedRange<Int> {
        let saneRange = self.saneRange(for: lines.count)
        
        guard lines.count > 2,
            let first = lines[saneRange.lowerBound] as? String,
            let last = lines[saneRange.upperBound] as? String else {
                return self
        }
        
        let lowerBound = first.trimmingCharacters(in: .newlines).isEmpty ? saneRange.lowerBound + 1 : saneRange.lowerBound
        let upperBound = last.trimmingCharacters(in: .newlines).isEmpty ? saneRange.upperBound - 1 : saneRange.upperBound
        
        return lowerBound...upperBound
    }
}
