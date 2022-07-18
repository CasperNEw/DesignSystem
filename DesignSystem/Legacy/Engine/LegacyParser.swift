//
//  LegacyParser.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 14/07/2022.
//

import UIKit

// swiftlint:disable identifier_name

class LegacyParser: Decodable {
    // MARK: - Properties

    private var themes: [String: LegacyParser.Theme] {
        get { return _themes ?? [:] }
        set { _themes = newValue }
    }

    private var attributes: [String: LegacyParser.Attribute] {
        get { return _attributes ?? [:] }
        set { _attributes = newValue }
    }

    private var _themes: [String: LegacyParser.Theme]?
    private var _attributes: [String: LegacyParser.Attribute]?

    enum CodingKeys: String, CodingKey {
        case _themes = "themes"
        case _attributes = "attributes"
    }

    // MARK: - Publics

    func getThemes() -> [LegacyTheme] {
        var resultArray: [LegacyTheme] = []

        for (themeName, theme) in themes {
            guard let key = LegacyThemeKey(rawValue: themeName) else { continue }
            var themeAttributes: [String: LegacyAttribute] = [:]

            for (attributeName, attribute) in attributes {
                var fontDescriptor: UIFontDescriptor?

                var fontName = attribute.font ?? ""
                var fontSizeName = attribute.textSize ?? "0"

                if let typeface = searchTypefaces(typeface: attribute.typeface ?? "", theme: theme) {
                    fontName = typeface.font ?? ""
                    fontSizeName = typeface.textSize ?? "0"
                }

                if let font = searchFont(font: fontName, theme: theme) {
                    fontDescriptor = UIFontDescriptor().withFamily(font.family ?? "").withFace(font.weight ?? "")
                }

                let fontSize = searchSizes(size: fontSizeName, theme: theme)

                let themeColors = getColorsDictionary(colorsRawDict: attribute.colors ?? [:], theme: theme)

                let newAttribute = LegacyAttribute(
                    key: attributeName,
                    colors: themeColors,
                    fontDescriptor: fontDescriptor,
                    fontSize: fontSize
                )

                themeAttributes[attributeName] = newAttribute
            }

            let newTheme = LegacyTheme(
                key: key,
                isDark: theme.isDark,
                attributes: themeAttributes
            )

            resultArray.append(newTheme)
        }

        return resultArray
    }

    func update(with parser: LegacyParser) {
        for theme in parser.themes where themes.keys.contains(theme.key) {
            themes[theme.key] = themes[theme.key]! + parser.themes[theme.key]!
        }
        for theme in parser.themes where !themes.keys.contains(theme.key) {
            themes[theme.key] = theme.value
        }
        for attribute in parser.attributes where attributes.keys.contains(attribute.key) {
            attributes[attribute.key] = attributes[attribute.key]! + parser.attributes[attribute.key]!
        }
        for attribute in parser.attributes where !attributes.keys.contains(attribute.key) {
            attributes[attribute.key] = attribute.value
        }
    }

    // MARK: - Privates

    private func searchFont(font: String, theme: LegacyParser.Theme) -> LegacyParser.Font? {
        if let result = theme.fonts?[font] {
            return result
        }

        if let parentTheme = themes[theme.parent ?? ""] {
            return searchFont(font: font, theme: parentTheme)
        }

        return nil
    }

    private func searchSizes(size: String, theme: LegacyParser.Theme) -> CGFloat? {
        if let result = theme.sizes?[size] {
            return result
        }

        if let parentTheme = themes[theme.parent ?? ""] {
            return searchSizes(size: size, theme: parentTheme)
        }

        return nil
    }

    private func searchTypefaces(typeface: String, theme: LegacyParser.Theme) -> LegacyParser.Typeface? {
        if let result = theme.typefaces?[typeface] {
            return result
        }

        if let parentTheme = themes[theme.parent ?? ""] {
            return searchTypefaces(typeface: typeface, theme: parentTheme)
        }

        return nil
    }

    private func getColorsDictionary(colorsRawDict: [String: String], theme: LegacyParser.Theme) -> [String: UIColor] {
        return Dictionary(uniqueKeysWithValues: colorsRawDict.compactMap { key, value in
            guard let color = searchColors(color: value, theme: theme) else {
                return nil
            }
            return (key, color)
        })
    }

    private func searchColors(color: String, theme: LegacyParser.Theme) -> UIColor? {
        if let result = theme.colors?[color] {
            return UIColor(hex: result)
        }

        if let parentTheme = themes[theme.parent ?? ""] {
            return searchColors(color: color, theme: parentTheme)
        }

        return nil
    }
}

// MARK: - Parse Types

private extension LegacyParser {
    struct Theme: Decodable {
        var name: String
        var isDark: Bool
        var parent: String?
        var typefaces: [String: Typeface]?
        var sizes: [String: CGFloat]?
        var fonts: [String: Font]?
        var colors: [String: String]?

        static func + (lhs: Theme, rhs: Theme) -> Theme {
            var result = lhs
            for size in (rhs.sizes ?? [:]) where !(result.sizes ?? [:]).keys.contains(size.key) {
                result.sizes?[size.key] = size.value
            }
            for font in (rhs.fonts ?? [:]) where !(result.fonts ?? [:]).keys.contains(font.key) {
                result.fonts?[font.key] = font.value
            }
            for color in (rhs.colors ?? [:]) where !(result.colors ?? [:]).keys.contains(color.key) {
                result.colors?[color.key] = color.value
            }
            for typeface in (rhs.typefaces ?? [:]) where !(result.typefaces ?? [:]).keys.contains(typeface.key) {
                result.typefaces?[typeface.key] = typeface.value
            }
            return result
        }
    }

    struct Attribute: Decodable {
        var font: String?
        var textSize: String?
        var typeface: String?
        var colors: [String: String]?

        static func + (lhs: Attribute, rhs: Attribute) -> Attribute {
            var result = lhs
            for color in (rhs.colors ?? [:]) where !(result.colors ?? [:]).keys.contains(color.key) {
                result.colors?[color.key] = color.value
            }
            return result
        }
    }

    struct Font: Decodable {
        var family: String?
        var weight: String?
    }

    struct Typeface: Decodable {
        var textSize: String?
        var font: String?
    }
}

// MARK: - UIColor with Hex

fileprivate extension UIColor {
    convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        var mutableString = hex

        if hex.count == 7 {
            mutableString.append("FF")
        }

        if hex.hasPrefix("#") {
            let start = mutableString.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(mutableString[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
