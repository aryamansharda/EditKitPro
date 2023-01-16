import Foundation

struct KotlinGenerator {
    static func generate(with viewModel: ModelInfo) -> String {
        var kotlin = ""
        kotlin += kotlinParcelable(with: viewModel)
        return kotlin
    }

    private static func kotlinParcelable(with viewModel: ModelInfo) -> String {
        var kotlin = "data class \(viewModel.name)(\n"
        kotlin += kotlinValues(from: viewModel.properties)
        kotlin += ")\n"
        return kotlin
    }

    private static func kotlinValues(from properties: [String: String]) -> String {
        var kotlin = ""
        for key in properties.keys.sorted() {
            guard let value = properties[key] else { continue }
            kotlin += "    val \(update(key: key)): \(value),"

            if key != properties.keys.sorted().last {
                kotlin += "\n"
            }
        }
        kotlin += "\n"
        return kotlin
    }
}

private extension KotlinGenerator {
    static func update(key: String) -> String {
        let characterSet = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890_")
        let newKey = key.filter { characterSet.contains($0) }

        if keywords.contains(newKey) {
            return "`\(newKey)`"
        }

        return newKey
    }

    static var keywords: [String] {
        "as class break continue do else for fun false if in interface super return object package null is try throw true this typeof typealias when while val var".components(separatedBy: " ")
    }
}
