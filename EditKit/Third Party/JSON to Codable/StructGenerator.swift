import Foundation

typealias ModelInfo = (name: String, properties: [String: String])

struct StructGenerator {
    static var currentNode: String?

    static func generate(with parent: Node) -> ModelInfo {
        var properties: [String: String] = [:]

        parent.children.forEach { node in
            properties[node.key] = node.valueType
        }

        currentNode = parent.name

        return ModelInfo(name: parent.name, properties: properties)
    }
}
