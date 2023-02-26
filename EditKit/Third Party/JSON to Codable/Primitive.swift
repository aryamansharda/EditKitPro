import Foundation

enum CustomType {
    case object
    case array
    case list
}

enum Primitive {
    case array(String), custom(CustomType), list(String)
    case bool, date, double, int, string, url, any

    var description: String {
        switch self {
        case .array: return "Array"
        case .bool: return "Bool"
        case .date: return "Date"
        case .double: return "Double"
        case .int: return "Int"
        case .list: return "List"
        case .string: return "String"
        case .url: return "URL"
        case .any: return "Any"
        case .custom: return "Custom"
        }
    }
}
