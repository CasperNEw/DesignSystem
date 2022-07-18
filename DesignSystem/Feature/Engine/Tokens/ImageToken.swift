//
//  ImageToken.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/07/2022.
//

import UIKit

/// Токен изображения
///
/// Адаптируется под текущую тему и пользовательский интерфейс
public enum ImageToken: String, Hashable {
    case icPaintbrush
    case ilBeer
}

// MARK: - Image
extension ImageToken {
    /// Изображение на основе текущей темы приложения и пользовательского интерфейса
    public var image: UIImage? {
        switch self {
        case .icPaintbrush:
            return Assets.Icons.paintbrush
        case .ilBeer:
            return ThemeProvider.shared.currentTheme.isDark
                ? Assets.Illustration.beerDark
                : Assets.Illustration.beerLight
        }
    }
}
