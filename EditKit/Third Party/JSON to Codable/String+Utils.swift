import Foundation

extension String {
    /// Adds brackets around String
    func appendBrackets() -> String {
        return "[\(self)]"
    }

    /// Adds brackets around String
    func appendCarrots() -> String {
        return "<\(self)>"
    }
    
    /**
     Capitalized the first letter in a string. Doesn't set any letters lowercase.

     While String has a capitalized representation, the resulting String
     will lowercase letters in the string that are capitalized.
     */
    func capitalize() -> String {
        return prefix(1).uppercased() + self.dropFirst()
    }

    /**
     Converts snake_case to camelCase

     foo_bar -> fooBar
     */
    func camelCased() -> String {
        guard contains("_") else { return self }
        return self
            .split(separator: "_")
            .enumerated()
            .map { $0.offset > 0 ? $0.element.capitalized : $0.element.lowercased() }
            .joined()
    }

    /**
     Appends brackets to singular objects in an array.

     Foos -> [Foo]
     */
    func objectArray(from json: Any?) -> String? {
        guard json is [[String: Any]] else { return self }
        return singular(from: json).appendBrackets()
    }

    /**
     Appends brackets to singular objects in an array.

     Foos -> [Foo]
     */
    func objectList(from json: Any?) -> String? {
        guard json is [[String: Any]] else { return self }
        return "List\(singular(from: json).appendCarrots())"
    }

    /**
     Returns the json key singular if the value is an array of objects.

     "Foos": [
        {
            "bar": "quuz",
            "baz": "norf"
        }
     ]

     Result: Foo

     "Foos": {
        "bar": "quuz",
        "baz": "norf"
     }

     Result: Foos

     */
    func singular(from value: Any? = nil) -> String {
         guard value is [[String: Any]] else { return self }

        if suffix(3) == "ies" {
            return dropLast(3) + "y"
        }
        
        if last == "s" {
            return dropLast().description
        }

        return self
    }

    /**
     Creates an editor placeholder.
     */
    init(placeholder: String) {
        self = "<#\(placeholder)#>"
    }
}
