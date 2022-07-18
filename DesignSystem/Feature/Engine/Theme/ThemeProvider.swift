//
//  ThemeProvider.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/07/2022.
//

import UIKit

/// Протокол провайдера темы
protocol ThemeProviderProtocol: AnyObject {
    /// Текущая тема приложения
    var currentTheme: Theme { get }
    /// Установка новой темы в приложении
    func applyTheme(_ theme: Theme)
}

// MARK: - ThemeProvider

/// Провайдер темы
final public class ThemeProvider: ThemeProviderProtocol {
    public static let shared = ThemeProvider()

    // MARK: - Private

    private var storage: ThemeStorageProtocol

    private init() {
        storage = ThemeStorage()
        currentTheme = storage.load() ?? Theme.defaultTheme
    }

    // MARK: - ThemeProviderProtocol

    public private(set) var currentTheme: Theme {
        didSet {
            if #available(iOS 13.0, *) {
                UIApplication.shared.windows.forEach({
                    $0.overrideUserInterfaceStyle = currentTheme.userInterfaceStyle
                })
            } else {
                NotificationCenter.default.post(name: .didChangeThemeNotification, object: nil)
            }
        }
    }

    public func applyTheme(_ theme: Theme) {
        guard currentTheme != theme else { return }
        storage.save(theme)
        currentTheme = theme
    }
}
