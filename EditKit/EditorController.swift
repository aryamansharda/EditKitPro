//
//  EditorController.swift
//  EditKit
//
//  Created by Aryaman Sharda on 12/14/22.
//

import XcodeKit
import AppKit

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

    static func handle(with invocation: XCSourceEditorCommandInvocation, completionHandler: ((Error?) -> Void)?) {

        // Fail fast if there is no text selected at all or there is no text in the file
        guard let commandIdentifier = EditorCommandIdentifier(rawValue: invocation.commandIdentifier) else { return }

        switch commandIdentifier {
        case .sortImports:
            // MARK: DONE
            ImportSorter().perform(with: invocation) { _ in
                print("Error")
            }
        case .sortLinesByLength:
            // MARK: DONE
            SortSelectedLinesByLength().perform(with: invocation) { _ in
                print("Error")
            }
        case .sortLinesAlphabetically:
            // MARK: DONE
            SortSelectedLinesByAlphabetically().perform(with: invocation) { _ in
                print("Error")
            }
        case .stripTrailingWhitespaceInFile:
            StripTrailingWhitespaceCommand.perform(with: invocation)
        case .alignAroundEquals:
            // MARK: DONE
            // This appears to work now, but Xcode can format lines slightly differently
            // Sometimes there will be a few millimeters of misalignment
            // When you check in VSCode, everything is as it should be
            AlignAroundEqualsCommand.perform(with: invocation)
        case .formatCodeForSharing:
            // MARK: DONE
            // This doesn't work on Slack regardless
            FormatCodeForSharingCommand.perform(with: invocation)
        case .formatAsMultiLine:
            /// This only works on single lines, it starts goofing up otherwise.
            // TODO: Maybe the fix is to just find all of the new lines and treat them as separate things
            let formatAsMultiLineService = FormatAsMultiLine()
            formatAsMultiLineService.perform(with: invocation) { _ in
                // TODO: Handle errors eventually
            }
        case .autoCreateExtensionMarks:
            // TODO: This has potential, but you need to make sure it doesn't duplicate existing MARKS
            // Maybe create an array of supported marks and then remove the ones that have been found
            // The approach of finding the first line where the keyword apepars seems reasonable
            // Maybe process needs to rest nart on every struct, enum, and class (v2?)
            AutoMarkCommand().perform(with: invocation) { _ in
                print("Done")
            }
        case .wrapInIfDef:
            // MARK: DONE
            WrapInIfDefCommand.perform(with: invocation)
        case .wrapInLocalizedString:
            // MARK: DONE
            WrapInLocalizedStringCommand.perform(with: invocation)
        case .searchOnGoogle, .searchOnStackOverflow, .searchOnGitHub:
            // MARK: DONE
            SearchOnPlatform().perform(with: invocation) { _ in
                // TODO: Handle errors
            }
        case .convertJSONtoCodable:
            // MARK: DONE
            ConvertJSONToCodableCommand().perform(with: invocation) { _ in
                // TODO: Handle errors
            }
        case .beautifyJSON:
            // MARK: DONE
            BeautifyJSONCommand().perform(with: invocation) { _ in

            }
        case .createTypeDefinition:
            // MARK: DONE
            CreateTypeDefinitionCommand().perform(with: invocation) { _ in
                // TODO: Handle errors
            }
        case .disableView:
            // MARK: DONE
            ToggleBraceLines().perform(with: invocation) { _ in
                invocation.buffer.selections.removeAllObjects()
            }
        case .disableOuterView:
            // MARK: DONE
            ToggleBraceLine().perform(with: invocation) { _ in
                invocation.buffer.selections.removeAllObjects()
            }
        case .deleteOuterView:
            // MARK: DONE
            RemoveBraceLine().perform(with: invocation) { _ in
                invocation.buffer.selections.removeAllObjects()
            }
        case .deleteView:
            // MARK: DONE
            RemoveBraceLines().perform(with: invocation) { _ in
                invocation.buffer.selections.removeAllObjects()
            }
        }
    }
}
