import SwiftUI

public extension Color {
    /// Namespace to prevent naming collisions with static accessors on
    /// SwiftUI's Color.
    ///
    /// Xcode's autocomplete allows for easy discovery of design system colors.
    /// At any call site that requires a color, type `Color.DesignSystem.<esc>`
    struct DesignSystem {
        public static let dark900 = Color(red: 0.027450980618596077, green: 0.0117647061124444, blue: 0.01568627543747425, opacity: 1)
        public static let dark800 = Color(red: 0.03529411926865578, green: 0.019607843831181526, blue: 0.0235294122248888, opacity: 1)
        public static let dark700 = Color(red: 0.04313725605607033, green: 0.0313725508749485, blue: 0.0313725508749485, opacity: 1)
        public static let dark600 = Color(red: 0.05098039284348488, green: 0.04313725605607033, blue: 0.04313725605607033, opacity: 1)
        public static let dark500Default = Color(red: 0.0625, green: 0.0625, blue: 0.0625, opacity: 1)
        public static let light400 = Color(red: 0.43529412150382996, green: 0.43529412150382996, blue: 0.43529412150382996, opacity: 1)
        public static let light300 = Color(red: 0.7176470756530762, green: 0.7176470756530762, blue: 0.7176470756530762, opacity: 1)
        public static let light200 = Color(red: 0.9058823585510254, green: 0.9058823585510254, blue: 0.9058823585510254, opacity: 1)
        public static let light100 = Color(red: 0.9529411792755127, green: 0.9529411792755127, blue: 0.9529411792755127, opacity: 1)
        public static let white = Color(red: 1, green: 1, blue: 1, opacity: 1)
        public static let success = Color(red: 0.5372549295425415, green: 0.8470588326454163, blue: 0.3764705955982208, opacity: 1)
        public static let error = Color(red: 1, green: 0.4431372582912445, blue: 0.2666666805744171, opacity: 1)
        public static let warning = Color(red: 0.9450980424880981, green: 0.8941176533699036, blue: 0.22745098173618317, opacity: 1)
        public static let primary900Default = Color(red: 0.11372549086809158, green: 0.30588236451148987, blue: 0.5372549295425415, opacity: 1)
        public static let primary800 = Color(red: 0.20392157137393951, green: 0.3764705955982208, blue: 0.5843137502670288, opacity: 1)
        public static let primary700 = Color(red: 0.29019609093666077, green: 0.4431372582912445, blue: 0.6313725709915161, opacity: 1)
        public static let primary600 = Color(red: 0.3803921639919281, green: 0.5137255191802979, blue: 0.6745098233222961, opacity: 1)
        public static let contrast900Default = Color(red: 0.9843137264251709, green: 0.8196078538894653, blue: 0.6352941393852234, opacity: 1)
        public static let contrast800 = Color(red: 0.9843137264251709, green: 0.8392156958580017, blue: 0.6705882549285889, opacity: 1)
        public static let constrast700 = Color(red: 0.9882352948188782, green: 0.8549019694328308, blue: 0.7098039388656616, opacity: 1)
        public static let constrast600 = Color(red: 0.9882352948188782, green: 0.8745098114013672, blue: 0.7411764860153198, opacity: 1)
        public static let secondary900Default = Color(red: 0.9686274528503418, green: 0.572549045085907, blue: 0.33725491166114807, opacity: 1)
        public static let secondary800 = Color(red: 0.9725490212440491, green: 0.615686297416687, blue: 0.40784314274787903, opacity: 1)
        public static let secondary700 = Color(red: 0.9764705896377563, green: 0.6549019813537598, blue: 0.47058823704719543, opacity: 1)
        public static let secondary600 = Color(red: 0.9764705896377563, green: 0.7058823704719543, blue: 0.5372549295425415, opacity: 1)
    }
}

