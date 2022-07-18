//
//  LegacyAttributes.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 12/07/2022.
//

import UIKit

public struct LegacyAttribute {
    public var key: String
    public var colors: [String: UIColor]

    private var fontDescriptor: UIFontDescriptor?
    private var fontSize: CGFloat?

    public var font: UIFont? {
        guard
            let fontDescriptor = fontDescriptor,
            let fontSize = fontSize
        else {
            return nil
        }
        return UIFont(descriptor: fontDescriptor, size: fontSize)
    }

    public init(
        key: String,
        colors: [String: UIColor],
        fontDescriptor: UIFontDescriptor?,
        fontSize: CGFloat?
    ) {
        self.key = key
        self.colors = colors
        self.fontDescriptor = fontDescriptor
        self.fontSize = fontSize
    }
}

public extension LegacyAttribute {
    var backgroundColor: UIColor? {
        return colors["backgroundColor"]
    }

    var tintColor: UIColor? {
        return colors["tintColor"]
    }
}
