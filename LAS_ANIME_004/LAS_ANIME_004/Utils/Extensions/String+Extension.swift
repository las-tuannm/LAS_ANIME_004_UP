//
//  String+Extension.swift
//  BaseRxswift_MVVM
//
//  Created by Khanh Vu on 27/09/2023.
//

import Foundation
import UIKit
import RxSwift

extension String {
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    func htmlAttributedString(size: CGFloat, color: UIColor) -> NSAttributedString? {
        let htmlTemplate = """
            <!doctype html>
            <html>
              <head>
                <style>
                  body {
                    color: \(color.toHexString());
                    font-family: -apple-system;
                    font-size: \(size)px;
                  }
                </style>
              </head>
              <body>
                \(self)
              </body>
            </html>
            """
        
        guard let data = htmlTemplate.data(using: .utf8) else {
            return nil
        }
        
        guard let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        ) else {
            return nil
        }
        
        return attributedString
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func isURL() -> Bool {
        // Regular expression pattern để kiểm tra xem văn bản có phải là URL hay không
        let pattern = "(?i)\\b((?:https?://|www\\.)\\S+)\\b"
        
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            let range = NSRange(location: 0, length: self.utf16.count)
            let matches = regex.matches(in: self, options: [], range: range)
            return matches.count > 0
        }
        return false
    }
    
    func preHandleURL() -> String {
        return self.replacingOccurrences(of: " ", with: "_")
    }
    
    
    func toAttributedStringWithColor(color: UIColor) -> NSAttributedString {
        let attributedText = NSAttributedString(string: self, attributes: [NSAttributedString.Key.foregroundColor: color])
        return attributedText
    }
    
    func toAttributedStringWithUnderlineAndColor(underline: Bool = false, color: UIColor) -> NSAttributedString{
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(.foregroundColor, value: color, range: NSRange.init(location: 0, length: attributedString.length))
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange.init(location: 0, length: attributedString.length))
        return attributedString
    }
    
    func removeAllSpace() -> String {
        let stringWithoutSpaces = self.replacingOccurrences(of: " ", with: "")
        return stringWithoutSpaces
    }
    
    func trimSpaceAndNewLine() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
