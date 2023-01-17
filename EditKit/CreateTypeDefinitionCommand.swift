//
//  CreateTypeDefinitionCommand.swift
//  EditKit
//
//  Created by Aryaman Sharda on 1/16/23.
//

import Foundation
import XcodeKit

fileprivate extension NSArray {

    func safeObject(atIndex index: Int) -> Any? {
        if index < count {
            return self[index]
        }

        return nil
    }
}

fileprivate extension Sequence {
    func findFirstOccurence(_ block: (Iterator.Element) -> Bool) -> Iterator.Element? {
        for x in self where block(x) {
            return x
        }

        return nil
    }

    func some(_ block: (Iterator.Element) -> Bool) -> Bool {
        return findFirstOccurence(block) != nil
    }

    func all(_ block: (Iterator.Element) -> Bool) -> Bool {
        return findFirstOccurence { !block($0) } == nil
    }
}

private enum UIKitClass: String {
    case view = "UIView"
    case button = "UIButton"
    case viewController = "UIViewController"
    case tableView = "UITableView"
    case tableViewCell = "UITableViewCell"
    case collectionView = "UICollectionView"
    case collectionViewCell = "UICollectionViewCell"

    var detectedEndings: [String] {
        switch self {
        case .view:
            return ["View", "view"]
        case .button:
            return ["Button", "button"]
        case .viewController:
            return ["Controller"]
        case .tableView:
            return ["TableView"]
        case .tableViewCell:
            return ["Cell"]
        case .collectionView:
            return ["CollectionView"]
        case .collectionViewCell:
            return ["CollectionViewCell", "CollectionCell"]
        }
    }

    static func detectSuperclass(forTypeName name: String) -> UIKitClass? {
        // check tableViewCell after collectionViewCell to give it a chance to be detected
        let candidates: [UIKitClass] = [.view, .button, .viewController, .tableView,
                                        .collectionViewCell, .collectionView, .tableViewCell]
        return candidates.findFirstOccurence {
            return $0.detectedEndings.findFirstOccurence { name.hasSuffix($0) } != nil
        }
    }
}

private enum Type {

case classType(parentType: UIKitClass?)
case structType
case enumType
case protocolType

    static func propableType(forFileName name: String) -> Type {

        if let detectedClass = UIKitClass.detectSuperclass(forTypeName: name) {
            return .classType(parentType: detectedClass)
        }

        if name.hasSuffix("Protocol") || name.hasSuffix("able") {
            return .protocolType
        }

        return .classType(parentType: nil)
    }

    func declarationCode(forTypeName name: String, tabWidth: Int) -> String? {
        let s: String? = {
            switch self {
            case .classType(parentType: let type):
                return "class \(name)" + (type.map { ": \($0.rawValue)" } ?? "")
            case .protocolType:
                return "protocol \(name) "
            default:
                return nil
            }
        }()
        return s.map { "\n" + $0 + " {\n\(String(repeating: " ", count: tabWidth))\n}" }
    }
}

class CreateTypeDefinitionCommand: NSObject, XCSourceEditorCommand {

    private func setCursor(atLine line: Int, column: Int, invocation: XCSourceEditorCommandInvocation) {
        let range = XCSourceTextRange()
        let position = XCSourceTextPosition(line: line, column: column)
        range.start = position
        range.end = position
        invocation.buffer.selections.setArray([range])
    }

    private func trimEmptyLinesAtTheEnd(_ invocation: XCSourceEditorCommandInvocation) {
        while (invocation.buffer.lines.lastObject as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            invocation.buffer.lines.removeLastObject()
        }
    }

    private func lineHasDeclaration(_ line: String) -> Bool {
        let line = line.trimmingCharacters(in: .whitespacesAndNewlines)
        let declarations = ["class", "struct", "enum", "protocol", "extension", "func", "var", "let"]
        return declarations.some { line.hasPrefix($0) }
    }

    private func lineHasUIKitImport(_ line: String) -> Bool {
        return line.trimmingCharacters(in: .whitespacesAndNewlines) == "import UIKit"
    }

    // "//  Classname.swift" -> "Classname"
    private func fileName(fromFileNameComment comment: String) -> String? {

        let comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)

        let commentPrefix = "//"
        guard comment.hasPrefix(commentPrefix) else { return nil }

        let swiftExtensionSuffix = ".swift"
        guard comment.hasSuffix(swiftExtensionSuffix) else { return nil }

        let startIndex = comment.index(comment.startIndex, offsetBy: commentPrefix.count)
        let endIndex = comment.index(comment.endIndex, offsetBy: -swiftExtensionSuffix.count)

        return comment[startIndex..<endIndex].trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {

        defer { completionHandler(nil) } // showing an error feels ugly, just do nothing in case of an error

        guard invocation.buffer.contentUTI == "public.swift-source" else { return }
        guard let secondLine = invocation.buffer.lines.safeObject(atIndex: 1) as? String else { return }
        guard let fileName = fileName(fromFileNameComment: secondLine) else { return }
        guard fileName.rangeOfCharacter(from: CharacterSet.letters.inverted) == nil else { return }
        guard invocation.buffer.lines.all({ !lineHasDeclaration($0 as? String ?? "") }) else { return }

        let type = Type.propableType(forFileName: fileName)
        if let code = type.declarationCode(forTypeName: fileName, tabWidth: invocation.buffer.tabWidth) {

            trimEmptyLinesAtTheEnd(invocation)

            switch type {
            case .classType(parentType: let parentType) where parentType != nil:
                if invocation.buffer.lines.all({ !lineHasUIKitImport($0 as? String ?? "") }) {
                    invocation.buffer.lines.add("import UIKit\n")
                }
            default:
                break
            }

            invocation.buffer.lines.add(code)
            setCursor(atLine: invocation.buffer.lines.count - 2, column: invocation.buffer.tabWidth, invocation: invocation)
        }
    }
}