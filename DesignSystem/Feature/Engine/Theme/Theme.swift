//
//  Theme.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/07/2022.
//

import UIKit

extension Notification.Name {
    /// Уведомление, которое публикуется в iOS 12, когда пользователь изменяет тему приложения
    static let didChangeThemeNotification = Notification.Name("didChangeThemeNotification")
}

/// Тема приложения
public enum Theme: Int {
    /// Светлая тема
    case light = 1
    /// Темная тема
    case dark = 2
    /// Системная тема
    @available(iOS 13.0, *)
    case system = 0

    /// Инициализатор
    /// - Parameters:
    ///   - style: Стиль, связанный с пользовательским интерфейсом
    public init(style: UIUserInterfaceStyle) {
        switch style {
        case .unspecified:
            if #available(iOS 13.0, *) {
                self = .system
            } else {
                self = .light
            }
        case .light:
            self = .light
        case .dark:
            self = .dark
        @unknown default:
            self = .light
        }
    }

    /// Стиль, связанный с пользовательским интерфейсом
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return .unspecified
        }
    }

    /// Является ли текущий стиль интерфейса приложения темным
    public var isDark: Bool {
        switch self {
        case .light:
            return false
        case .dark:
            return true
        case .system:
            if #available(iOS 13.0, *) {
                return UITraitCollection.current.userInterfaceStyle == .dark
            } else {
                return false
            }
        }
    }

    /// Базовая тема, используется когда нет информации о сохраненной ранее теме
    static var defaultTheme: Theme {
        if #available(iOS 13.0, *) {
            return .system
        } else {
            return .light
        }
    }
}
