//
//  ThemeObserver.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/07/2022.
//

import Foundation

/// Протокол наблюдателя, который умеет подписываться на ивенты связанные со сменой темы в приложении
public protocol ThemeObserver: ThemeSubscriber {
    /// Подписаться на ивент
    func observe(event: ThemeEvent)
}

public extension ThemeObserver {
    func observe(event: ThemeEvent) {
        switch event {
        case .didChangeTheme:
            // Метод `_updateAppearance` определен в расширении класса `UIView` и протоколе `ThemeSubscriber`.
            // При обновлении темы, в iOS 12, вызывается метод у каждой UIView реализующей протокол Styleable.
            // Далее вызывается этот же метод в протоколе ThemeSubscriber,
            // который вызывает все методы этого же протокола и провоцирует применение всех стилей.
            NotificationCenter.default.addObserver(
                self,
                selector: Selector(("_updateAppearance")),
                name: .didChangeThemeNotification,
                object: nil
            )
        }
    }
}
