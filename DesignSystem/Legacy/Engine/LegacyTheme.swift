//
//  LegacyTheme.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 12/07/2022.
//

import Foundation

public enum LegacyThemeKey: String, CaseIterable {
    case base
    case light
    case dark
}

@objc public class LegacyTheme: NSObject {
    public let key: LegacyThemeKey
    public let isDark: Bool
    public var attributes: [String: LegacyAttribute]

    init(
        key: LegacyThemeKey,
        isDark: Bool,
        attributes: [String: LegacyAttribute]
    ) {
        self.key = key
        self.isDark = isDark
        self.attributes = attributes
    }

    public func attribute(named: String) -> LegacyAttribute? {
        return attributes[named]
    }
}
