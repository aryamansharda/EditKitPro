import Foundation

public extension Data {
    /**
     Serializes the JSON data from a file.

     Will first check for a single key value pair object.
     If that fails it will look for an array of key value pairs and take use the first object.
     */
    func serialized() -> [String: Any]? {
        var object: Any?

        do {
            object = try JSONSerialization.jsonObject(with: self, options : .allowFragments)
        } catch {
            print("Error writing file: \(error.localizedDescription)")
        }

        if let json = object as? [String: Any] ?? (object as? [[String: Any]])?.first {
            return json
        }

        return nil
    }
}
