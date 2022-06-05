//
//  Localizable.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//


// MARK: Localizable
public protocol UILocalizable {
    var localizableKey: String? { get set }
}

extension UILabel: UILocalizable {
    @IBInspectable public var localizableKey: String? {
        get { return nil }
        set(key) {
            text = key?.localized
        }
    }
}

extension UIButton: UILocalizable {
    @IBInspectable public var localizableKey: String? {
        get { return nil }
        set(key) {
            setTitle(key?.localized, for: .normal)
        }
    }
}

public protocol UITextFieldLocalizable {
    var placeholderLocalizableKey: String? { get set }
}

extension UITextField: UITextFieldLocalizable {
    @IBInspectable public var placeholderLocalizableKey: String? {
        get { return nil }
        set(key) {
            placeholder = key?.localized
        }
    }
}

