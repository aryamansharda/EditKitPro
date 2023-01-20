//
//  AutoMarkCommand.swift
//  EditKit
//
//  Created by Aryaman Sharda on 1/16/23.
//

import Foundation
import XcodeKit

class AutoMarkCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        var lineClassMark: Int?
        var linePropertieMark: Int?
        var lineIBOutletMark: Int?
        var lineViewDidLoadMark: Int?
        var lineInitializersMark: Int?
        var lineIBActionMark: Int?
        var linePrivateMethodMark: Int?
        var linePublicMethodMark: Int?
        var lineExtensionMark: Int?

        func checkForExistingMarks() {
            let allLines = invocation.buffer.lines.map { $0 as! String }.joined()

            if allLines.contains("MARK: - IBOutlets") {
                lineIBOutletMark = 0
            }


            if allLines.contains("MARK: - Properties") {
                linePropertieMark = 0
            }

            if allLines.contains("MARK: - Initializers") {
                lineInitializersMark = 0
            }

            if allLines.contains("MARK: - IBOutlets") {
                lineIBOutletMark = 0
            }

            if allLines.contains("MARK: - View Lifecycle") {
                lineViewDidLoadMark = 0
            }

            if allLines.contains("MARK: - IBActions") {
                lineIBActionMark = 0
            }

            if allLines.contains("MARK: - Private Methods") {
                linePrivateMethodMark = 0
            }

            if allLines.contains("MARK: - Public Methods") {
                linePublicMethodMark = 0
            }

            if allLines.contains("MARK: - Extensions") {
                lineExtensionMark = 0
            }

        }

        checkForExistingMarks()

        // Find the main entity first
        for i in 0..<invocation.buffer.lines.count {
            let line = (invocation.buffer.lines[i] as! String).trimmingCharacters(in: .whitespacesAndNewlines)
            if (line.contains("class") || line.contains("struct") || line.contains("enum")) {
                lineClassMark = i
            }
        }

        for i in lineClassMark!..<invocation.buffer.lines.count {

            let line = (invocation.buffer.lines[i] as! String).trimmingCharacters(in: .whitespacesAndNewlines)

            if line.hasPrefix("//") {
                continue
            }

            let variableTypes = ["static var", "static let", "private var", "private let", "public var", "public let", "internal var", "internal let", "lazy var"]
            let matchingVariable = variableTypes.first { candidate in
                line.contains(candidate)
            }

            if line.contains("IBOutlet") && lineIBOutletMark == nil {
                invocation.buffer.lines.insert("    //MARK: - IBOutlets", at: i)
                lineIBOutletMark = i
                continue
            }

            if (matchingVariable != nil && !line.contains("IBOutlet")) && linePropertieMark == nil && lineClassMark != nil {
                invocation.buffer.lines.insert("    //MARK: - Properties", at: i)
                linePropertieMark = i
                continue
            }

            if (line.hasPrefix("init(") || line.hasPrefix("required init(") || line.hasPrefix("override init(")) && lineInitializersMark == nil && lineClassMark != nil {

                invocation.buffer.lines.insert("    //MARK: - Initializers", at: i)
                lineInitializersMark = i

            }

            if line.hasPrefix("@IBOutlet") && lineIBOutletMark == nil && lineClassMark != nil {

                invocation.buffer.lines.insert("    //MARK: - IBOutlets", at: i)
                lineIBOutletMark = i

            }

            if line.contains("viewDidLoad") && lineViewDidLoadMark == nil && lineClassMark != nil {

                invocation.buffer.lines.insert("    //MARK: - View Lifecycle", at: i)
                lineViewDidLoadMark = i-1
                linePropertieMark = 0

            }

            if line.hasPrefix("@IBAction") && lineIBActionMark == nil  && lineClassMark != nil {

                invocation.buffer.lines.insert("    //MARK: - IBActions", at: i)
                lineIBActionMark = i

            }

            if line.contains("private func") && linePrivateMethodMark == nil && lineClassMark != nil {

                invocation.buffer.lines.insert("    //MARK: - Private Methods", at: i)
                linePrivateMethodMark = i

            }

            if (line.hasPrefix("func") || line.hasPrefix("@objc func") || line.hasPrefix("override func")) && linePublicMethodMark == nil && lineClassMark != nil {

                invocation.buffer.lines.insert("    //MARK: - Public Methods", at: i)
                linePublicMethodMark = i

            }

            if line.hasPrefix("extension") && lineExtensionMark == nil {

                invocation.buffer.lines.insert("//MARK: - Extensions", at: i)
                lineExtensionMark = i

            }

        }

        completionHandler(nil)
    }

}
