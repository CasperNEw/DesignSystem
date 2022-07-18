//
//  UIColor+.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/07/2022.
//

import UIKit

extension UIColor {
    public static func dynamic(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor(dynamicProvider: { traitCollection in
                traitCollection.userInterfaceStyle == .dark ? dark : light
            })
        } else {
            return ThemeProvider.shared.currentTheme == .dark ? dark : light
        }
    }

    public static func dynamic(_ light: String, _ dark: String) -> UIColor {
        return UIColor.dynamic(light: UIColor(light), dark: UIColor(dark))
    }

    convenience init(_ hex: String) {
        let hexString = hex.replacingOccurrences(of: "#", with: "")
        var hexNumber: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&hexNumber)

        if hexString.count == 8 {
            self.init(
                red: CGFloat((hexNumber & 0xFF000000) >> 24) / 255.0,
                green: CGFloat((hexNumber & 0xFF0000) >> 16) / 255.0,
                blue: CGFloat((hexNumber & 0xFF00) >> 8) / 255.0,
                alpha: CGFloat(hexNumber & 0xFF) / 255.0
            )
            return
        }

        self.init(
            red: CGFloat((hexNumber & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hexNumber & 0xFF00) >> 8) / 255.0,
            blue: CGFloat(hexNumber & 0xFF) / 255.0,
            alpha: 1.0
        )
    }

    convenience init<T: RawRepresentable>(_ palette: T) where T.RawValue == String {
        self.init(palette.rawValue)
    }
}
