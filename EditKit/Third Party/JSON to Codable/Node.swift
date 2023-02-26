import Foundation

class Node: Codable, Copyable {
    /// This is the exact key from the json.
    var key: String

    /// Value type
    var valueType: String?

    /**
     Name of node.
     Capitalized representaion of the json key.
    */
    var name: String

    /// The node's parent
    var parent: Node?

    /// Array of children nodes
    var children: [Node] = []

    /**
     Generated model associated with Node.
     Nodes without children will not contain a generated model.
     */
    var model: String?

    /**
     The key's level in the JSON data.
     */
    var level: Int {
        var level: Int = 0

        ascend { _ in
            level += 1
        }

        return level
    }

    init(name: String) {
        self.key = ""
        self.name = name
    }

    init(key: String, value: Any? = nil, generatorType: GeneratorType) {
        self.key = key
        self.name = key.camelCased().capitalize().singular(from: value)
        self.setType(with: value, generatorType: generatorType)
    }

    required init(instance: Node) {
        self.key = instance.key
        self.valueType = instance.valueType

        name = instance.name
        children = instance.children
    }
}

extension Node {
    /**
     Appends a new child node to the current node.

     - Parameter child: The child node that will be appended
     */
    func add(child: Node) {
        children.append(child)
        child.parent = self
    }

    /**
     Removes a new child node from the current node when such node is a common node.

     - Parameter child: The child node that will be removed
     */
    func remove(common child: Node) {
        guard let index = children.firstIndex(of: child) else { return }
        children[index].children.removeAll()
    }

    /**
     Filters out any nodes that are the same and retains one.
     */
    func filter() {
        children = Array(Set(children))
    }

    /**
     Generates the model for the node.
     A model should only exist on nodes that have children.
     */
    func generateModel(for type: GeneratorType) {
        let generatedStruct = StructGenerator.generate(with: self)

        switch type {
        case .swift:
            model = SwiftGenerator.generate(with: generatedStruct)
        case .kotlin:
            model = KotlinGenerator.generate(with: generatedStruct)
        }
    }

    func updateType() {
        guard let type = valueType else { return }

        if type.contains("[") {
            valueType = name.appendBrackets()
        } else {
            valueType = name
        }
    }
}

private extension Node {
    /**
     Ascends from the current node through all of the parents.
     Handler will be executed each time a parent node is reached.
     */
    func ascend(handler: @escaping (Node) -> ()) {
        var node = self

        while node.parent != nil {
            guard let parent = node.parent else { continue }
            node = parent
            handler(node)
        }
    }

    func setType(with value: Any?, generatorType: GeneratorType) {
        guard let value = value, let type = generatorType.detectType(of: value) else { return }

        switch type {
        case .array(let type):
            valueType = type
        case .custom(let type):
            switch type {
            case .object:
                valueType = name
            case .array:
                valueType = name.objectArray(from: value)
            case .list:
                valueType = name.objectList(from: value)
            }
        default:
            valueType = type.description
        }
    }
}

extension Node: Equatable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.name == rhs.name && lhs.children == rhs.children
    }
}

extension Node: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(children)
    }
}
