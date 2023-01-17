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
        case sortLines = "EditKitPro.EditKit.SortLines"
        case sortLinesByLength = "EditKitPro.EditKit.SortLinesByLength"
        case stripTrailingWhitespaceInFile = "EditKitPro.EditKit.StripTrailingWhitespaceInFile"
        case alignAroundEquals = "EditKitPro.EditKit.AlignAroundEquals"
        case formatCodeForSharing = "EditKitPro.EditKit.FormatCodeForSharing"
        case formatAsMultiLine = "EditKitPro.EditKit.FormatAsMultiLine"
        case autoCreateExtensionMarks = "EditKitPro.EditKit.AutoCreateExtensionMarks"
        case wrapInIfDef = "EditKitPro.EditKit.WrapInIfDef"
        case wrapInLocalizedString = "EditKitPro.EditKit.WrapInLocalizedString"
        case searchOnGoogle = "EditKitPro.EditKit.SearchOnPlatform.Google"
        case searchOnStackOverflow = "EditKitPro.EditKit.SearchOnPlatform.StackOverflow"
        case searchOnGitHub = "EditKitPro.EditKit.SearchOnPlatform.GitHub"
        case convertJSONtoCodable = "EditKitPro.EditKit.ConvertJSONToCodable"
        case spellcheckComments = "EditKitPro.EditKit.SpellcheckComments"
        case beautifyJSON = "EditKitPro.EditKit.BeautifyJSON"

//        case deleteLines = "Thriller.Editor.DeleteLines";
//        case duplicateLines = "Thriller.Editor.DuplicateLines";
//        case copyLines = "Thriller.Editor.CopyLines";
//        case blockComment = "Thriller.Editor.BlockComment";
//        case convertJson = "Thriller.Editor.ConvertJsonToModel";
//        case convertProtobuf = "Thriller.Editor.ConvertProtobufToModel";

        // TODO: - sort import <>, "", oc, swift
        // TODO: - auto import anywhere
        // TODO: - generate sel interface oc, swift
        // TODO: - generate sel imp with select codes oc, swift
        // TODO: - generate statement with select expression oc, swift

        // TODO: - common wapper
        // TODO: - blcok common (wraps in /* and */

        // TODO: - alignment
        // TODO: - format

        // TODO: - upper case
        // TODO: - lower case

        // TODO: - need comment or not
        // TODO: - prefix support

        // Is upper case, lower case, starting block comments above really helpful?
    }

    /// handle all editor command
    static func handle(with invocation: XCSourceEditorCommandInvocation, completionHandler: ((Error?) -> Void)?) {

        // Fail fast if there is no text selected at all or there is no text in the file
        guard let commandIdentifier = EditorCommandIdentifier(rawValue: invocation.commandIdentifier) else { return }

        switch commandIdentifier {
        case .sortLines:
            print("Sort Lines")
        case .sortLinesByLength:
            print("Sort Lines By Length")
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
            // Maybe process needs to restart on every struct, enum, and class (v2?)
            AutoMarkCommand().perform(with: invocation) { _ in
                print("Done")
            }
//            AutoCreateExtensionMarksCommand.perform(with: invocation)
        case .wrapInIfDef:
            // MARK: DONE
            WrapInIfDefCommand.perform(with: invocation)
        case .wrapInLocalizedString:
            WrapInLocalizedStringCommand.perform(with: invocation)
        case .searchOnGoogle, .searchOnStackOverflow, .searchOnGitHub:
            SearchOnPlatform().perform(with: invocation) { _ in
                // TODO: Handle errors
            }
        case .convertJSONtoCodable:
            ConvertJSONToCodableCommand().perform(with: invocation) { _ in
                // TODO: Handle errors
            }
        case .spellcheckComments:
            SpellcheckCommentsCommand().perform(with: invocation) { _ in
                // TODO: Handle errors
            }
        case .beautifyJSON:
            BeautifyJSONCommand().perform(with: invocation) { _ in

            }
        }
    }
}
