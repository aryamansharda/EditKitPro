import Foundation

extension Dictionary where Key == String {
    /**
     Returns a dictionary object if it is the value for the given key.
     */
    func value(from key: String) -> [String: Any]? {
        guard let dictionary = self[key] as? [String: Any] ?? (self[key] as? [[String: Any]])?.first else { return nil }
        return dictionary
    }
}
