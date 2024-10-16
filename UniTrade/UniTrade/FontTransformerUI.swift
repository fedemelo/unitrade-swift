//
//  FontTransformerUI.swift
//  UniTrade
//
//  Created by Santiago Martinez on 3/10/24.
//

import SwiftUI

extension UIFont {
    /// Convert SwiftUI Font to UIFont
    convenience init(_ font: Font) {
        switch font {
        case .largeTitle:
            self.init(descriptor: .preferredFontDescriptor(withTextStyle: .largeTitle), size: 34)
        case .title:
            self.init(descriptor: .preferredFontDescriptor(withTextStyle: .title1), size: 28)
        case .headline:
            self.init(descriptor: .preferredFontDescriptor(withTextStyle: .headline), size: 17)
        case .body:
            self.init(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 17)
        default:
            self.init(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 17)
        }
    }
}

extension UIColor {
    /// Convert SwiftUI Color to UIColor
    convenience init(_ color: Color) {
        self.init(cgColor: color.cgColor ?? UIColor.clear.cgColor)
    }
}

