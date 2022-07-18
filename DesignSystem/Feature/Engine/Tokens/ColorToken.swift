//
//  ColorToken.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/07/2022.
//

import UIKit

/// Токен цвета
///
/// Адаптируется под текущую тему приложения и пользовательский интерфейс
public enum ColorToken {
    // MARK: - Background
    case background

    // MARK: - BarButtonItem
    case barButtonItem
}

// MARK: - Color
extension ColorToken {
    /// Цвет на основе текущей темы приложения и пользовательского интерфейса
    public var color: UIColor {
        switch self {
        // MARK: - Background
        case .background:
            return UIColor.dynamic(Palette.Background.basicLight, Palette.Background.basicDark)

        // MARK: - BarButtonItem
        case .barButtonItem:
            return UIColor.dynamic(Palette.BarButtonItem.specialLight, Palette.BarButtonItem.specialDark)
        }
    }
}
