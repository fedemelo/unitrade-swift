import SwiftUI

public extension Font {
    /// Namespace to prevent naming collisions with static accessors on
    /// SwiftUI's Font.
    ///
    /// Xcode's autocomplete allows for easy discovery of design system fonts.
    /// At any call site that requires a font, type `Font.DesignSystem.<esc>`
    struct DesignSystem {
        public static let headline900 = Font.custom("Urbanist-Bold", size: 48)
        public static let headline800 = Font.custom("Urbanist-SemiBold", size: 36)
        public static let headline700 = Font.custom("Urbanist-SemiBold", size: 24)
        public static let heading100 = Font.custom("Inter-SemiBold", size: 24)
        public static let headline600 = Font.custom("Urbanist-Bold", size: 20)
        public static let headline500 = Font.custom("Urbanist-SemiBold", size: 16)
        public static let bodyText300 = Font.custom("Urbanist-Regular", size: 16)
        public static let headline400 = Font.custom("Urbanist-Bold", size: 14)
        public static let bodyText200 = Font.custom("Urbanist-Regular", size: 14)
        public static let headline300 = Font.custom("Urbanist-Bold", size: 12)
        public static let heading200 = Font.custom("Urbanist-SemiBold", size: 12)
        public static let bodyText100 = Font.custom("Urbanist-Regular", size: 12)
    }
}
