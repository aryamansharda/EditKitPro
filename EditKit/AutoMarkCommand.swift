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
        var lineExtensionMark:Int?

        for i in 0..<invocation.buffer.lines.count {

            let line = invocation.buffer.lines[i] as! String

            if line.contains("class") || line.contains("struct") || line.contains("enum") {
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

            if line.contains("init(") && lineInitializersMark == nil  {

                invocation.buffer.lines.insert("    //MARK: - Initializers", at: i)
                lineInitializersMark = i

            }

            if line.contains("IBOutlet") && lineIBOutletMark == nil  {

                invocation.buffer.lines.insert("    //MARK: - IBOutlets", at: i)
                lineIBOutletMark = i

            }

            if line.contains("viewDidLoad") && lineViewDidLoadMark == nil  {

                invocation.buffer.lines.insert("    //MARK: - View Lifecycle", at: i)
                lineViewDidLoadMark = i-1
                linePropertieMark = 0

            }

            if line.contains("IBAction") && lineIBActionMark == nil  {

                invocation.buffer.lines.insert("    //MARK: - IBActions", at: i)
                lineIBActionMark = i

            }

            if line.contains("private func") && linePrivateMethodMark == nil  {

                invocation.buffer.lines.insert("    //MARK: - Private Methods", at: i)
                linePrivateMethodMark = i

            }

            if line.contains("extension") && lineExtensionMark == nil {

                invocation.buffer.lines.insert("//MARK: - Extensions", at: i)
                lineExtensionMark = i

            }

        }

        if linePropertieMark == 0 && lineIBOutletMark == nil {

            invocation.buffer.lines.insert("    //MARK: - Properties", at: lineClassMark!+2)
            linePropertieMark = lineClassMark!+2
            invocation.buffer.lines.insert("", at: linePropertieMark!+1)
            invocation.buffer.lines.insert("", at: linePropertieMark!+1)
            invocation.buffer.lines.insert("    //MARK: - IBOutlets", at: linePropertieMark!+2)
            lineIBOutletMark = linePropertieMark!+2

        }

        completionHandler(nil)
    }

}
