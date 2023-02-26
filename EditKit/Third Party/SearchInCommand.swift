//
//  SearchInCommand.swift
//  EditKit
//
//  Created by Aryaman Sharda on 12/17/22.
//

import Foundation
import Cocoa
import XcodeKit

enum SearchEngine {
    case google, stackOverflow, github

    init(identifier: String) {
        guard let searchType = identifier.components(separatedBy: ".").last else {
            self = .google
            return
        }

        switch searchType {
        case "Google":
            self = .google
        case "StackOverflow":
            self = .stackOverflow
        case "GitHub":
            self = .github
        default:
            self = .google
        }
    }

    var urlPrefix: String {
        switch self {
        case .google:
            return "https://www.google.com/search?q="
        case .stackOverflow:
            return "https://stackoverflow.com/search?q="
        case .github:
            return "https://github.com/search?q="
        }
    }

    func url(with keyword: String) -> String {
        urlPrefix + keyword.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlHostAllowed)!
    }
}

final class SearchOnPlatform: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: (Error?) -> Void) {
        guard let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
            completionHandler(GenericError.default.intoNSError)
            return
        }

        let startIndex = selection.start.line
        let endIndex = selection.end.line

        let selectedRange = NSRange(location: startIndex, length: 1 + endIndex - startIndex)

        guard let selectedLines = invocation.buffer.lines.subarray(with: selectedRange) as? [String] else {
            completionHandler(GenericError.default.intoNSError)
            return
        }

        let keyword = selectedLines.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
        let engine = SearchEngine(identifier: invocation.commandIdentifier)

        openInSearchEngine(urlString: engine.url(with: keyword))

        completionHandler(nil)
    }

    private func openInSearchEngine(urlString: String) {
        guard let url = URL(string: urlString) else {
            // Invalid URL
            return
        }

        NSWorkspace.shared.open(url)
    }
}
