//
//  LegacyManager.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 12/07/2022.
//

import UIKit

extension Notification.Name {
    static let needToUpdateThemeNotification = Notification.Name("NeedToUpdateThemeNotification")
}

public final class LegacyManager {
    // MARK: - Properties

    private var parser: LegacyParser = LegacyParser()
    private var themes: [LegacyTheme] = []

    public static var shared: LegacyManager = LegacyManager()
    public private(set) var currentTheme: LegacyTheme?

    // MARK: - Publics

    public func configure(with jsons: [String]) {
        for json in jsons {
            guard
                let data = json.data(using: .utf8),
                let parser = try? JSONDecoder().decode(LegacyParser.self, from: data)
            else { continue }

            self.parser.update(with: parser)
        }
        themes = parser.getThemes()
    }

    public func set(theme: LegacyThemeKey, updateViews: (() -> Void)? = nil) {
        var key: LegacyThemeKey = theme
        if isDeviceBasedTheme {
            key = currentDeviceTheme
        }

        if let theme = themes.first(where: { $0.key == key }) {
            currentTheme = theme
            udpateAppearance()
            updateViews?()
            resetViews()
        }
    }

    public func attributesURL() -> [URL] {
        Bundle.main.urls(forResourcesWithExtension: "style", subdirectory: nil) ?? []
    }

    // MARK: - Privates

    private init() {
        addObservings()
    }

    private func udpateAppearance() {
        LegacyView.appearance().theme = currentTheme
        LegacyImageView.appearance().theme = currentTheme

        if #available(iOS 13.0.0, *) {
            let isDark = currentTheme?.isDark ?? false
            for window in UIApplication.shared.windows {
                window.overrideUserInterfaceStyle = isDark ? .dark : .light
            }
        }
    }

    private func resetViews() {
        let theme: [AnyHashable: Any] = ["theme": currentTheme!]
        NotificationCenter.default.post(
            name: .needToUpdateThemeNotification,
            object: nil,
            userInfo: theme
        )
    }

    // MARK: - Device Theme

    private enum DeviceTheme {
        case light
        case dark
    }

    private var deviceTheme: DeviceTheme = .light

    private var _isDeviceBasedTheme: Bool {
        get { UserDefaults.standard.bool(forKey: "isDeviceBasedTheme") }
        set { UserDefaults.standard.set(newValue, forKey: "isDeviceBasedTheme") }
    }

    public var isDeviceBasedTheme: Bool {
        get {
            if #available(iOS 13.0, *) { return _isDeviceBasedTheme }
            return false
        }
        set {
            _isDeviceBasedTheme = newValue
            if #available(iOS 13.0, *), _isDeviceBasedTheme == true {
                set(theme: currentDeviceTheme)
            }
        }
    }

    public var currentDeviceTheme: LegacyThemeKey {
        let themeKey: LegacyThemeKey
        if #available(iOS 13.0, *) {
            if deviceTheme == .dark {
                themeKey = .dark
            } else {
                themeKey = .light
            }
        } else {
            themeKey = .light
        }
        return themeKey
    }

    private func addObservings() {
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(updateDeviceTheme),
                name: UIApplication.didBecomeActiveNotification,
                object: nil
            )
        }
    }

    @objc private func updateDeviceTheme() {
        if #available(iOS 13.0, *) {
            if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
                deviceTheme = .dark
            } else {
                deviceTheme = .light
            }
        } else {
            deviceTheme = .light
        }

        if isDeviceBasedTheme {
            set(theme: currentDeviceTheme)
        }
    }
}
