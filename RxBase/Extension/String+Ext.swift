//
//  String+Ext.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//

import Foundation

extension String {
    static var firebaseConfigFilePath: String? {
        #if DEBUG || DEBUG_BUILD
        return Bundle.main.path(forResource: "GoogleService-Info",
                                ofType: "plist",
                                inDirectory: "GoogleInfoPlist/Dev")
        #elseif STAGING || STAGING_BUILD
        return Bundle.main.path(forResource: "GoogleService-Info",
                                ofType: "plist",
                                inDirectory: "GoogleInfoPlist/Staging")
        #else
        return Bundle.main.path(forResource: "GoogleService-Info",
                                ofType: "plist",
                                inDirectory: "GoogleInfoPlist/Production")
        #endif
    }
}

extension String {
    
    var localized: String {
        let path = Bundle.main.path(forResource: "ja", ofType: "lproj")
        let bundle = Bundle(path: path ?? "")
        return NSLocalizedString(self, tableName: nil, bundle: bundle ?? Bundle(), value: "", comment: "")
    }
    
    var containsSpecialCharacter: Bool {
        let regex = ".*[!&^%$#@()/*]+.*"
        let string = NSPredicate(format: "SELF MATCHES %@", regex)
        return string.evaluate(with: self)
    }
    
    var containsUpperCharacter: Bool {
        let capitalLetterRegEx = ".*[A-Z]+.*"
        let string = NSPredicate(format: "SELF MATCHES %@", capitalLetterRegEx)
        return string.evaluate(with: self)
    }
    
    var containsNumberCharacter: Bool {
        let capitalLetterRegEx = ".*[0-9]+.*"
        let string = NSPredicate(format: "SELF MATCHES %@", capitalLetterRegEx)
        return string.evaluate(with: self)
    }
    
    func verticalText() -> String {
        let chars = Array(self.trimmingCharacters(in: .whitespaces))
        return chars.map { "\($0)" } .joined(separator: "\n")
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font], context: nil
        )
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )
        return ceil(boundingBox.width)
    }
    
    func isValidEmail() -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    func resourceURL() -> URL? {
        guard let path = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        return URL(
            string: path
        )
    }
}

extension String {
    public var halfSize: String {
        let text: CFMutableString = NSMutableString(string: self) as CFMutableString
        CFStringTransform(text, nil, kCFStringTransformFullwidthHalfwidth, false)
        return text as String
    }
    
    public var fullSize: String {
        let text: CFMutableString = NSMutableString(string: self) as CFMutableString
        CFStringTransform(text, nil, kCFStringTransformFullwidthHalfwidth, true)
        return text as String
    }
    
    var standardized: String {
        self.trimmingCharacters(in: .whitespaces).lowercased().fullSize
    }
    
    var underLine: NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let attributeString = NSMutableAttributedString(
            string: self,
            attributes: attributes
        )
        return attributeString
    }
    
    public var sixCharacter: String {
        let text = self as NSString
        return text.substring(with: NSRange(location: 0,
                                            length: text.length > 6 ? 6
                                                : text.length)) as String + "..."
    }
    
    public var fiveCharacter: String {
        let text = self as NSString
        
        let subText = text.substring(with: NSRange(location: 0,
                                                   length: text.length > 10 ? 5
                                                       : text.length)) as String + "..."
        return subText
    }
}

extension String {
    func sizeOf(_ font: UIFont?) -> CGSize {
        return self.size(withAttributes: [.font: font as Any])
    }
}

