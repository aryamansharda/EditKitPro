import Foundation

struct KotlinTypeHandler {
    static func detectType(of value: Any) -> Primitive? {
        if value is [[String: Any]] {
            return .custom(.list)
        }

        if let array = value as? Array<Any> {
            guard let item = array.first else { return nil }
            guard let type = detectType(of: item) else { return nil }
            return .list("List<\(type.description)>")
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

        if value is String {
            return .string
        }

        return .any
    }
}
