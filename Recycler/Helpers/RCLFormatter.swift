//
//  Formatter.swift
//  testApp
//
//  Created by Ganna Melnyk on 3/4/18.
//  Copyright © 2018 Ganna Melnyk. All rights reserved.
//

import Foundation

class RCLFormatter {
    
    func decimalFormatter(text: String, range: NSRange, replacementString: String) -> NSString {
        let newString = (text as NSString).replacingCharacters(in: range, with: replacementString)
        let components = newString.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
        return components.joined(separator: "") as NSString
    }
    
    func formatString(text: NSString, length: Int) -> String {
        var index = 0 as Int
        let formattedString = NSMutableString()
        if length >= 2 {
            formattedString.append("+38(")
            index += 2
        }
        if length - index > 3 {
            let areaCode = text.substring(with: NSMakeRange(index, 3))
            formattedString.appendFormat("%@)", areaCode)
            index += 3
        }
        if length - index > 3 {
            let prefix = text.substring(with: NSMakeRange(index, 3))
            formattedString.appendFormat("%@-", prefix)
            index += 3
        }
        
        let remainder = text.substring(from: index)
        formattedString.append(remainder)
        return formattedString as String
        
    }
    
}


