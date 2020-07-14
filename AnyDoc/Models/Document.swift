//
//  Document.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/11/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import Foundation

struct Document {
    var uuid = UUID().uuidString
    var name: String
    var scans = [Scan]()
    
    static func generateDocumentName() -> String {
        let uuid = UUID().uuidString.prefix(8)
        let name = "document-\(uuid)"
        return name
    }
}

