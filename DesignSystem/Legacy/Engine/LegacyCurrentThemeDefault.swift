//
//  LegacyCurrentThemeDefault.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 14/07/2022.
//

import Foundation

extension Notification.Name {
    static let CurrentThemeDidChange = Notification.Name("CurrentThemeDidChange")
}

class LegacyCurrentThemeDefault {
    func themeDidChange(theme: LegacyThemeKey, deviceBased: Bool) {
        if deviceBased == false {
            current = theme
        }
    }

    static var shared: LegacyCurrentThemeDefault = {
        return LegacyCurrentThemeDefault()
    }()

    private var currentStoredString: String {
        get { UserDefaults.standard.string(forKey: "CurrentThemeDefault") ?? LegacyThemeKey.light.rawValue }
        set { UserDefaults.standard.set(newValue, forKey: "CurrentThemeDefault") }
    }

    private var currentStored: LegacyThemeKey {
        get { LegacyThemeKey(rawValue: currentStoredString) ?? .light }
        set { currentStoredString = newValue.rawValue }
    }

    var current: LegacyThemeKey {
        get { currentStored }
        set {
            currentStored = newValue
            notifyThemeChanged()
        }
    }

    private func notifyThemeChanged() {
        var userInfo: [String: LegacyThemeKey]
        userInfo = ["current": current]

        NotificationCenter.default.post(name: .CurrentThemeDidChange, object: nil, userInfo: userInfo)
    }
}
