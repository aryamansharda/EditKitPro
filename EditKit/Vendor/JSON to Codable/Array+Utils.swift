import Foundation

extension Array where Element: Hashable {
    /**
     Returns all unique elements in an array.

     [1, 2, 3, 3, 4, 5, 5, 5, 6] -> [1, 2, 4, 6]
     */
    var uniqueElements: [Element] {
        return Dictionary(grouping: self, by: { $0 }).compactMap { $1.count == 1 ? $0 : nil }
    }

    /**
     Returns all common elements in an array.

     [1, 2, 3, 3, 4, 5, 5, 5, 6] -> [3, 5]
     */
    var commonElements: [Element] {
        return self.filter { !uniqueElements.contains($0) }
    }

    func contains(optional: Element?) -> Bool {
        guard let element = optional else { return false }
        return contains(element)
    }
}
