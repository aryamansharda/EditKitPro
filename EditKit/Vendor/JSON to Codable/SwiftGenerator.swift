import Foundation

struct SwiftGenerator {
    static func generate(with viewModel: ModelInfo) -> String {
        var swift = ""
        swift += swiftObject(with: viewModel)
        return swift
    }

    private static func swiftObject(with viewModel: ModelInfo) -> String {
        var swift = "struct \(viewModel.name): Codable {\n"
        swift += swiftFor(properties: viewModel.properties)
        swift += "}\n"
        return swift
    }

    private static func swiftFor(properties: [String: String]) -> String {
        var swift = ""
        swift += swiftCodingKeys(from: properties.keys.sorted())
        swift += swiftVariables(from: properties)
        swift += swiftInit(from: properties)
        return swift
    }

    private static func swiftCodingKeys(from keys: [String]) -> String {
        var swift = "    enum CodingKeys: String, CodingKey, CaseIterable {\n"
        keys.forEach { key in
            let newKey = update(key: key)
            if newKey != key {
                swift += "        case \(newKey) = \"\(key)\"\n"
            } else {
                swift += "        case \(key)\n"
            }
        }
        swift += "    }\n\n"
        return swift
    }

    private static func swiftVariables(from properties: [String: String]) -> String {
        var swift = ""
        for key in properties.keys.sorted() {
            guard let value = properties[key] else { continue }
            swift += "    var \(update(key: key)): \(value)\n"
        }
        swift += "\n"
        return swift
    }

    private static func swiftInit(from properties: [String: String]) -> String {
        var swift = ""
        swift += "    init("
        for (index, key) in properties.keys.sorted().enumerated() {
            guard let value = properties[key] else { continue }
            if index != properties.keys.count - 1 {
                swift += "\(update(key: key)): \(value), "
            } else {
                swift += "\(update(key: key)): \(value)"
            }
        }
        swift += ") {\n"
        properties.keys.sorted().forEach { key in
            swift += "        self.\(update(key: key)) = \(update(key: key))\n"
        }
        swift += "    }\n"
        return swift
    }
}

private extension SwiftGenerator {
    static func update(key: String) -> String {
        let characterSet = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890_")
        var newKey = key.filter { characterSet.contains($0) }

        if let char = newKey.first, let _ = Int(String(char)) {
            newKey = newKey.camelCased()
            return "_\(newKey)"
        }

        if keywords.contains(newKey) {
            return "`\(newKey)`"
        }

        if newKey.contains("_") {
            return newKey.camelCased()
        }

        return newKey
    }

    static var keywords: [String] {
        "Any as associatedtype break case catch class continue default defer deinit do else enum extension fallthrough false fileprivate for func guard if import in init inout internal is let nil open operator private protocol public repeat rethrows return Self self static struct subscript super switch Type throw throws true try typealias var where while".components(separatedBy: " ")
    }
}
