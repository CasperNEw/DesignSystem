//
//  ThemeStorage.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/07/2022.
//

import Foundation

/// Протокол хранилища темы
public protocol ThemeStorageProtocol: AnyObject {
    func load() -> Theme?
    func save(_ theme: Theme)
}

/// Хранилище темы
final class ThemeStorage: ThemeStorageProtocol {
    static let key = "AppTheme"

    func load() -> Theme? {
        return Theme(rawValue: UserDefaults.standard.integer(forKey: ThemeStorage.key))
    }

    func save(_ theme: Theme) {
        UserDefaults.standard.set(theme.rawValue, forKey: ThemeStorage.key)
    }
}
