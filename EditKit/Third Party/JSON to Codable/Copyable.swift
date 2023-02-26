import Foundation

protocol Copyable {
    init(instance: Self)
}

extension Copyable {
    func copy() -> Self {
        return .init(instance: self)
    }
}
