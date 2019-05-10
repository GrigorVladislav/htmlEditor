//
//  Document.swift
//  htmlEditor
//
//  Created by Admin on 09.05.2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class Document: UIDocument {
    var text: String?
    
    override func contents(forType typeName: String) throws -> Any {
        if let content = text {
            let length = content.lengthOfBytes(using: String.Encoding.utf8)
            return NSData(bytes:content, length: length)
        } else {
            return Data()
        }
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        if let userContent = contents as? Data, userContent.count > 0 {
            text = NSString(bytes: (contents as AnyObject).bytes,
                                  length: userContent.count,
                                  encoding: String.Encoding.utf8.rawValue) as String?
        }
    }
}

