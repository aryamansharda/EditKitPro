import Foundation

struct SwiftTypeHandler {
    static func detectType(of value: Any) -> Primitive? {
        if value is [[String: Any]] {
            return .custom(.array)
        }

        if let array = value as? Array<Any> {
            guard let item = array.first else { return nil }
            guard let type = detectType(of: item) else { return nil }
            return .array("[\(type.description)]")
        }

        if value is [String: Any] {
            return .custom(.object)
        }

        if let x = value as? NSNumber {
            if x === NSNumber(value: true) || x === NSNumber(value: false) {
                return .bool
            }
        }

        if value is Double {
            return .double
        }

        if value is Int {
            return .int
        }

        if let string = value as? String {
            if isURL(string) {
                return .url
            }

            if isDate(string) {
                return .date
            }

            return .string
        }

        return .any
    }

    static func isURL(_ string: String) -> Bool {
        NSPredicate(
            format:"SELF MATCHES %@",
            argumentArray: ["((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"]
        )
        .evaluate(with: string)
    }

    static func isDate(_ string: String) -> Bool {
        if DateFormatter.iso8601.date(from: string) != nil {
            return true
        }

        if DateFormatter.dateAndTime.date(from: string.replacingOccurrences(of: "+00:00", with: "")) != nil {
            return true
        }

        if DateFormatter.dateOnly.date(from: string) != nil {
            return true
        }

        return false
    }
}
