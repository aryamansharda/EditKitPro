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
        var lineClassMark:Int?
        var linePropertieMark:Int?
        var lineIBOutletMark:Int?
        var lineViewDidLoadMark:Int?
        var lineInitializersMark:Int?
        var lineIBActionMark:Int?
        var linePrivateMethodMark:Int?
        var linePublicMethodMark:Int?
        var lineExtensionMark:Int?

        for i in 0..<invocation.buffer.lines.count {

            let line = (invocation.buffer.lines[i] as! String).trimmingCharacters(in: .whitespacesAndNewlines)

            if (line.contains("class") || line.contains("struct") || line.contains("enum")) {
                lineClassMark = i
            }

            if (line.contains("var") || line.contains("let")) && linePropertieMark == nil && lineClassMark != nil {

                if line.contains("IBOutlet") && lineIBOutletMark == nil  {

                    if !(invocation.buffer.lines[i] as! String).contains("MARK: - IBOutlets") {
                        invocation.buffer.lines.insert("    //MARK: - IBOutlets", at: i)
                    }

                    lineIBOutletMark = i
                    linePropertieMark = 0

                } else {

                    invocation.buffer.lines.insert("    //MARK: - Properties", at: i)
                    linePropertieMark = i

                }

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
