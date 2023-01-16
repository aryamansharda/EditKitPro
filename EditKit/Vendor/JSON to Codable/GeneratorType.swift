import Foundation

public enum GeneratorType {
    case swift
    case kotlin

    func detectType(of value: Any) -> Primitive? {
        switch self {
        case .swift:
            return SwiftTypeHandler.detectType(of: value)
        case .kotlin:
            return KotlinTypeHandler.detectType(of: value)
        }
    }
}
