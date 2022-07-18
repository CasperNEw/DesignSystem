//
//  UIWindow+.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/07/2022.
//

import UIKit

extension UIWindow {
    /// Применяем для окна стиль пользовательского интерфейса на основании текущей темы из `ThemeProvider`
    func overrideStyle() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = ThemeProvider.shared.currentTheme.userInterfaceStyle
        }
    }
}
