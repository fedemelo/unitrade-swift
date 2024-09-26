//
//  Color.swift
//  UniTrade
//
//  Colors automatically extracted from Figma mockup with https://figmatoswift.com/
//  Methods created by Federico Melo Barrero on 26/09/24.
//

import SwiftUI

public extension Color {
    struct DesignSystem {
        
        public static func dark900(for colorScheme: ColorScheme = .light) -> Color {
            return useComplementaryForDarkMode(for: "dark900", colorScheme: colorScheme)
        }
        
        public static func dark800(for colorScheme: ColorScheme = .light) -> Color {
            return useComplementaryForDarkMode(for: "dark800", colorScheme: colorScheme)
        }
        
        public static func dark700(for colorScheme: ColorScheme = .light) -> Color {
            return useComplementaryForDarkMode(for: "dark700", colorScheme: colorScheme)
        }
        
        public static func dark600(for colorScheme: ColorScheme = .light) -> Color {
            return useComplementaryForDarkMode(for: "dark600", colorScheme: colorScheme)
        }
        
        public static func dark500(for colorScheme: ColorScheme = .light) -> Color {
            return useComplementaryForDarkMode(for: "dark500", colorScheme: colorScheme)
        }
        
        public static func light400(for colorScheme: ColorScheme = .light) -> Color {
            return useComplementaryForDarkMode(for: "light400", colorScheme: colorScheme)
        }
        
        public static func light300(for colorScheme: ColorScheme = .light) -> Color {
            return useComplementaryForDarkMode(for: "light300", colorScheme: colorScheme)
        }
        
        public static func light200(for colorScheme: ColorScheme = .light) -> Color {
            return useComplementaryForDarkMode(for: "light200", colorScheme: colorScheme)
        }
        
        public static func light100(for colorScheme: ColorScheme = .light) -> Color {
            return useComplementaryForDarkMode(for: "light100", colorScheme: colorScheme)
        }
        
        public static func success(for colorScheme: ColorScheme = .light) -> Color {
            return createColor(from: "success")
        }
        
        public static func error(for colorScheme: ColorScheme = .light) -> Color {
            return createColor(from: "error")
        }
        
        public static func warning(for colorScheme: ColorScheme = .light) -> Color {
            return createColor(from: "warning")
        }
        
        public static func primary900(for colorScheme: ColorScheme = .light) -> Color {
            return createColor(from: "primary900")
        }
        
        public static func primary800(for colorScheme: ColorScheme = .light) -> Color {
            return createColor(from: "primary800")
        }
        
        public static func primary700(for colorScheme: ColorScheme = .light) -> Color {
            return createColor(from: "primary700")
        }
        
        public static func primary600(for colorScheme: ColorScheme = .light) -> Color {
            return createColor(from: "primary600")
        }
        
        public static func contrast900(for colorScheme: ColorScheme = .light) -> Color {
            return createColor(from: "contrast900")
        }
        
        public static func contrast800(for colorScheme: ColorScheme = .light) -> Color {
            return createColor(from: "contrast800")
        }
        
        public static func contrast700(for colorScheme: ColorScheme = .light) -> Color {
            return createColor(from: "contrast700")
        }
        
        public static func contrast600(for colorScheme: ColorScheme = .light) -> Color {
            return createColor(from: "contrast600")
        }
        
        public static func secondary900(for colorScheme: ColorScheme = .light) -> Color {
            return createColor(from: "secondary900")
        }
        
        public static func secondary800(for colorScheme: ColorScheme = .light) -> Color {
            return createColor(from: "secondary800")
        }
        
        public static func secondary700(for colorScheme: ColorScheme = .light) -> Color {
            return createColor(from: "secondary700")
        }
        
        public static func secondary600(for colorScheme: ColorScheme = .light) -> Color {
            return createColor(from: "secondary600")
        }
        
        private static let colorDictionary: [String: (red: Double, green: Double, blue: Double)] = [
            "dark900": (red: 0.027, green: 0.012, blue: 0.016),
            "dark800": (red: 0.035, green: 0.020, blue: 0.024),
            "dark700": (red: 0.043, green: 0.031, blue: 0.031),
            "dark600": (red: 0.051, green: 0.043, blue: 0.043),
            "dark500": (red: 0.063, green: 0.063, blue: 0.063),
            "light400": (red: 0.435, green: 0.435, blue: 0.435),
            "light300": (red: 0.718, green: 0.718, blue: 0.718),
            "light200": (red: 0.906, green: 0.906, blue: 0.906),
            "light100": (red: 0.953, green: 0.953, blue: 0.953),
            "success": (red: 0.537, green: 0.847, blue: 0.376),
            "error": (red: 1, green: 0.443, blue: 0.267),
            "warning": (red: 0.945, green: 0.894, blue: 0.227),
            "primary900": (red: 0.114, green: 0.306, blue: 0.537),
            "primary800": (red: 0.204, green: 0.376, blue: 0.584),
            "primary700": (red: 0.290, green: 0.443, blue: 0.631),
            "primary600": (red: 0.380, green: 0.514, blue: 0.675),
            "contrast900": (red: 0.984, green: 0.820, blue: 0.635),
            "contrast800": (red: 0.984, green: 0.839, blue: 0.671),
            "contrast700": (red: 0.988, green: 0.855, blue: 0.710),
            "contrast600": (red: 0.988, green: 0.875, blue: 0.741),
            "secondary900": (red: 0.969, green: 0.573, blue: 0.337),
            "secondary800": (red: 0.973, green: 0.616, blue: 0.408),
            "secondary700": (red: 0.976, green: 0.655, blue: 0.471),
            "secondary600": (red: 0.976, green: 0.706, blue: 0.537)
        ]
        
        public static func createColor(from colorName: String, opacity: Double = 1.0) -> Color {
            let rgbValues = colorDictionary[colorName] ?? (red: 0.0, green: 0.0, blue: 0.0)
            return Color(
                red: rgbValues.red,
                green: rgbValues.green,
                blue: rgbValues.blue,
                opacity: opacity
            )
        }
        
        private static func useComplementaryForDarkMode(for colorName: String, colorScheme: ColorScheme = .light) -> Color {
            colorScheme == .dark ? calculateComplementary(from: colorName) : createColor(from: colorName)
        }
        
        private static func calculateComplementary(from colorName: String, opacity: Double = 1.0) -> Color {
            let rgbValues = colorDictionary[colorName] ?? (red: 1, green: 1, blue:1)
            return Color(
                red: 1.0 - rgbValues.red,
                green: 1.0 - rgbValues.green,
                blue: 1.0 - rgbValues.blue,
                opacity: opacity
            )
        }
    }
}
