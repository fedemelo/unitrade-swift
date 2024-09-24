//
//  JustifiedText.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 24/09/24.
//

import SwiftUI

struct JustifiedText: UIViewRepresentable {
    let text: String
    let font: Font
    let textColor: Color
    
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontForContentSizeCategory = true
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.text = text
        uiView.font = convertToUIFont(font)
        uiView.textColor = UIColor(textColor)
    }
    
    private func convertToUIFont(_ font: Font) -> UIFont {
        switch font {
            case Font.DesignSystem.headline900:
                return UIFont(name: "Urbanist-Bold", size: 48) ?? UIFont.systemFont(ofSize: 48)
            case Font.DesignSystem.headline800:
                return UIFont(name: "Urbanist-SemiBold", size: 36) ?? UIFont.systemFont(ofSize: 36)
            case Font.DesignSystem.headline700:
                return UIFont(name: "Urbanist-SemiBold", size: 24) ?? UIFont.systemFont(ofSize: 24)
            case Font.DesignSystem.heading100:
                return UIFont(name: "Inter-SemiBold", size: 24) ?? UIFont.systemFont(ofSize: 24)
            case Font.DesignSystem.headline600:
                return UIFont(name: "Urbanist-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20)
            case Font.DesignSystem.headline500:
                return UIFont(name: "Urbanist-SemiBold", size: 16) ?? UIFont.systemFont(ofSize: 16)
            case Font.DesignSystem.bodyText300:
                return UIFont(name: "Urbanist-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
            case Font.DesignSystem.headline400:
                return UIFont(name: "Urbanist-Bold", size: 14) ?? UIFont.systemFont(ofSize: 14)
            case Font.DesignSystem.bodyText200:
                return UIFont(name: "Urbanist-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
            case Font.DesignSystem.headline300:
                return UIFont(name: "Urbanist-Bold", size: 12) ?? UIFont.systemFont(ofSize: 12)
            case Font.DesignSystem.heading200:
                return UIFont(name: "Urbanist-SemiBold", size: 12) ?? UIFont.systemFont(ofSize: 12)
            case Font.DesignSystem.bodyText100:
                return UIFont(name: "Urbanist-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)
            default:
                return UIFont.systemFont(ofSize: 16)
        }
    }
}
