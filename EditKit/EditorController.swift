//
//  EditorController.swift
//  EditKit
//
//  Created by Aryaman Sharda on 12/14/22.
//

import XcodeKit
import AppKit

extension Error where Self: LocalizedError {
    var intoNSError: NSError  {
        let userInfo: [String : Any] = [
            NSLocalizedFailureReasonErrorKey : errorDescription ?? String()
        ]

        return NSError(domain: String(), code: 0, userInfo: userInfo)
    }
}

enum GenericError: Error, LocalizedError {
    case `default`

    var errorDescription: String? {
        switch self {
        case .default:
            return "Something went wrong. Please check your selection and try again."
        }
    }
}

struct EditorController {
    enum EditorCommandIdentifier: String {
        case alignAroundEquals              = "EditKitPro.EditKit.AlignAroundEquals"
        case autoCreateExtensionMarks       = "EditKitPro.EditKit.AutoCreateExtensionMarks"
        case beautifyJSON                   = "EditKitPro.EditKit.BeautifyJSON"
        case convertJSONtoCodable           = "EditKitPro.EditKit.ConvertJSONToCodable"
        case createTypeDefinition           = "EditKitPro.EditKit.CreateTypeDefinition"
        case formatAsMultiLine              = "EditKitPro.EditKit.FormatAsMultiLine"
        case formatCodeForSharing           = "EditKitPro.EditKit.FormatCodeForSharing"
        case searchOnGitHub                 = "EditKitPro.EditKit.SearchOnPlatform.GitHub"
        case searchOnGoogle                 = "EditKitPro.EditKit.SearchOnPlatform.Google"
        case searchOnStackOverflow          = "EditKitPro.EditKit.SearchOnPlatform.StackOverflow"
        case sortImports                    = "EditKitPro.EditKit.SortImports"
        case sortLinesAlphabetically        = "EditKitPro.EditKit.SortLinesAlphabetically"
        case disableOuterView              = "EditKitPro.EditKit.DisableOuterView"
        case disableView              = "EditKitPro.EditKit.DisableView"
        case deleteOuterView              = "EditKitPro.EditKit.DeleteOuterView"
        case deleteView              = "EditKitPro.EditKit.DeleteView"
        case sortLinesByLength              = "EditKitPro.EditKit.SortLinesByLength"
        case stripTrailingWhitespaceInFile  = "EditKitPro.EditKit.StripTrailingWhitespaceInFile"
        case wrapInIfDef                    = "EditKitPro.EditKit.WrapInIfDef"
        case wrapInLocalizedString          = "EditKitPro.EditKit.WrapInLocalizedString"
    }

    static func handle(with invocation: XCSourceEditorCommandInvocation, completionHandler: (Error?) -> Void) {

        // Fail fast if there is no text selected at all or there is no text in the file
        guard let commandIdentifier = EditorCommandIdentifier(rawValue: invocation.commandIdentifier) else { return }

        switch commandIdentifier {
        case .sortImports:
            print("Sort imports")
            // MARK: DONE
//            ImportSorter().perform(with: invocation) { error in
//                completionHandler(error)
//            }
        case .sortLinesByLength:
            SortSelectedLinesByLength.perform(with: invocation, completionHandler: completionHandler)

        case .sortLinesAlphabetically:
            SortSelectedLinesByAlphabetically().perform(with: invocation, completionHandler: completionHandler)

        case .stripTrailingWhitespaceInFile:
            StripTrailingWhitespaceCommand.perform(with: invocation, completionHandler: completionHandler)

        case .alignAroundEquals:
            /// This appears to work now, but Xcode can format lines slightly differently
            /// Sometimes there will be a few millimeters of misalignment
            /// When you check in VSCode, everything is as it should be
            AlignAroundEqualsCommand.perform(with: invocation, completionHandler: completionHandler)

        case .formatCodeForSharing:
            // This doesn't work on Slack regardless
            FormatCodeForSharingCommand.perform(with: invocation, completionHandler: completionHandler)

        case .formatAsMultiLine:
            /// This only works on single lines, it starts goofing up otherwise.
            FormatAsMultiLine().perform(with: invocation, completionHandler: completionHandler)

        case .autoCreateExtensionMarks:
            AutoMarkCommand().perform(with: invocation, completionHandler: completionHandler)

        case .wrapInIfDef:
            WrapInIfDefCommand.perform(with: invocation, completionHandler: completionHandler)

        case .wrapInLocalizedString:
            WrapInLocalizedStringCommand.perform(with: invocation, completionHandler: completionHandler)

        case .searchOnGoogle, .searchOnStackOverflow, .searchOnGitHub:
            SearchOnPlatform().perform(with: invocation, completionHandler: completionHandler)

        case .convertJSONtoCodable:
            ConvertJSONToCodableCommand().perform(with: invocation, completionHandler: completionHandler)

        case .beautifyJSON:
            BeautifyJSONCommand().perform(with: invocation, completionHandler: completionHandler)

        case .createTypeDefinition:
            // MARK: DONE
            CreateTypeDefinitionCommand().perform(with: invocation) { _ in
                // TODO: Handle errors
            }
        case .disableView:
            ToggleBraceLines().perform(with: invocation, completionHandler: completionHandler)

        case .disableOuterView:
            ToggleBraceLine().perform(with: invocation, completionHandler: completionHandler)

        case .deleteOuterView:
            RemoveBraceLine().perform(with: invocation, completionHandler: completionHandler)

        case .deleteView:
            RemoveBraceLines().perform(with: invocation, completionHandler: completionHandler)

        }
    }
}
