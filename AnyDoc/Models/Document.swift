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
    
    init(name: String, scans: [Scan]) {
        self.name = name
        self.scans = scans
    }
    
    init(scans: [Scan]) {
        self.name = "document-\(uuid.prefix(8))"
        self.scans = scans
    }
}

