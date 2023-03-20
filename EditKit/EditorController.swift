//
//  EditorController.swift
//  EditKit
//
//  Created by Aryaman Sharda on 12/14/22.
//

import XcodeKit
import AppKit

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
        case alignAroundEquals = "EditKitPro.EditKit.AlignAroundEquals"
        case autoCreateExtensionMarks = "EditKitPro.EditKit.AutoCreateExtensionMarks"
        case beautifyJSON = "EditKitPro.EditKit.BeautifyJSON"
        case convertJSONtoCodable = "EditKitPro.EditKit.ConvertJSONToCodable"
        case convertSelectionToUppercase = "EditKitPro.EditKit.ConvertToUppercase"
        case convertSelectionToLowercase = "EditKitPro.EditKit.ConvertToLowercase"
        case convertSelectionToSnakeCase = "EditKitPro.EditKit.ConvertToSnakeCase"
        case convertSelectionToCamelCase = "EditKitPro.EditKit.ConvertToCamelCase"
        case convertSelectionToPascalCase = "EditKitPro.EditKit.ConvertToPascalCase"
        case createTypeDefinition = "EditKitPro.EditKit.CreateTypeDefinition"
        case formatAsMultiLine = "EditKitPro.EditKit.FormatAsMultiLine"
        case formatCodeForSharing = "EditKitPro.EditKit.FormatCodeForSharing"
        case searchOnGitHub = "EditKitPro.EditKit.SearchOnPlatform.GitHub"
        case searchOnGoogle = "EditKitPro.EditKit.SearchOnPlatform.Google"
        case searchOnStackOverflow = "EditKitPro.EditKit.SearchOnPlatform.StackOverflow"
        case sortImports = "EditKitPro.EditKit.SortImports"
        case sortLinesAlphabeticallyAscending = "EditKitPro.EditKit.SortLinesAlphabeticallyAscending"
        case sortLinesAlphabeticallyDescending = "EditKitPro.EditKit.SortLinesAlphabeticallyDescending"
        case disableOuterView = "EditKitPro.EditKit.DisableOuterView"
        case disableView = "EditKitPro.EditKit.DisableView"
        case deleteOuterView = "EditKitPro.EditKit.DeleteOuterView"
        case deleteView = "EditKitPro.EditKit.DeleteView"
        case sortLinesByLength = "EditKitPro.EditKit.SortLinesByLength"
        case stripTrailingWhitespaceInFile = "EditKitPro.EditKit.StripTrailingWhitespaceInFile"
        case wrapInIfDef = "EditKitPro.EditKit.WrapInIfDef"
        case wrapInLocalizedString = "EditKitPro.EditKit.WrapInLocalizedString"
        case initFromSelcectedProperties = "EditKitPro.EditKit.InitializerFromSelection"
    }

    static func handle(with invocation: XCSourceEditorCommandInvocation, completionHandler: (Error?) -> Void) {

        // Fail fast if there is no text selected at all or there is no text in the file
        guard let commandIdentifier = EditorCommandIdentifier(rawValue: invocation.commandIdentifier) else { return }

        switch commandIdentifier {
        case .sortImports:
            ImportSorter().perform(with: invocation, completionHandler: completionHandler)

        case .sortLinesByLength:
            SortSelectedLinesByLength.perform(with: invocation, completionHandler: completionHandler)

        case .sortLinesAlphabeticallyAscending:
            SortSelectedLinesByAlphabeticallyAscending().perform(with: invocation, completionHandler: completionHandler)

        case .sortLinesAlphabeticallyDescending:
            SortSelectedLinesByAlphabeticallyDescending().perform(with: invocation, completionHandler: completionHandler)

        case .stripTrailingWhitespaceInFile:
            StripTrailingWhitespaceCommand.perform(with: invocation, completionHandler: completionHandler)

        case .alignAroundEquals:
            AlignAroundEqualsCommand.perform(with: invocation, completionHandler: completionHandler)

        case .formatCodeForSharing:
            // Note: this doesn't work on Slack regardless
            FormatCodeForSharingCommand.perform(with: invocation, completionHandler: completionHandler)

        case .formatAsMultiLine:
            // This only works on single lines
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
            CreateTypeDefinitionCommand().perform(with: invocation, completionHandler: completionHandler)

        case .disableView:
            ToggleBraceLines().perform(with: invocation, completionHandler: completionHandler)

        case .disableOuterView:
            ToggleBraceLine().perform(with: invocation, completionHandler: completionHandler)

        case .deleteOuterView:
            RemoveBraceLine().perform(with: invocation, completionHandler: completionHandler)

        case .deleteView:
            RemoveBraceLines().perform(with: invocation, completionHandler: completionHandler)
        case .initFromSelcectedProperties:
            InitializerFromSelectionCommand.perform(with: invocation, completionHandler: completionHandler)
        case .convertSelectionToUppercase:
            SelectionConversionCommand.perform(with: invocation, operation: .uppercase, completionHandler: completionHandler)
        case .convertSelectionToLowercase:
            SelectionConversionCommand.perform(with: invocation, operation: .lowercase, completionHandler: completionHandler)
        case .convertSelectionToSnakeCase:
            SelectionConversionCommand.perform(with: invocation, operation: .snakeCase, completionHandler: completionHandler)
        case .convertSelectionToCamelCase:
            SelectionConversionCommand.perform(with: invocation, operation: .camelCase, completionHandler: completionHandler)
        case .convertSelectionToPascalCase:
            SelectionConversionCommand.perform(with: invocation, operation: .pascalCase, completionHandler: completionHandler)
        }
    }
}
