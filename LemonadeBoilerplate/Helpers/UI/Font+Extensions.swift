//
//  Font+Extensions.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 22.11.2021.
//
import UIKit
extension UIFont {
    /**
     Generate font
     
     - parameter name: Default value = Avenir.
     - parameter type: Default value = Black.
     - parameter size: Font size
     - returns: UIFont
     ```
     */
    static func generateFont( _ name : String = "Avenir"
                              , type : FontType = .black
                              , size : CGFloat) -> UIFont {
        let fontName = name + "-" + type.rawValue
        return .init(name: fontName, size: size)!
    }
}
internal enum FontType : String {
    case black       = "Black"
    case medium      = "Medium"
    case heavy       = "Heavy"
    case light       = "Light"
}
