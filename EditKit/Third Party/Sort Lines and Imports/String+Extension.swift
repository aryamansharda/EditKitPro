//
//  String+Extension.swift
//  SorterExtension
//
//  Created by aniltaskiran on 24.05.2020.
//  Copyright © 2020 Anıl. All rights reserved.
//

import Foundation

extension String {
    var isBlank: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isImportLine: Bool {
        hasPrefix("import ")
    }
    
    var removeImportPrefix: String {
        replacingOccurrences(of: "import ", with: "")
    }
    
    var removeNewLine: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
