//
//  SourceEditorCommand.swift
//  EditKit
//
//  Created by Aryaman Sharda on 12/14/22.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        EditorController.handle(with: invocation, completionHandler: completionHandler)
        completionHandler(nil)
    }
}
