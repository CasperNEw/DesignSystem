//
//  ThemeSubscriber.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/07/2022.
//

import UIKit

// swiftlint:disable identifier_name

/// Протокол подписчика, который умеет реагировать на смену темы в приложении
public protocol ThemeSubscriber: AnyObject {
    /// Обновление  представления, автоматически вызывается при назначении superview и при смене темы в iOS 12
    ///
    /// В данном методе необходимо производить работу с абстракциями над UIColor
    func updateAppearance()

    /// Обновление стиля интерфейса, автоматически вызывается при смене UIUserInterfaceStyle
    ///
    /// В данном методе необходимо производить темозависимую настройку элементов CoreAnimation и установку ImageToken
     func updateUserInterfaceStyle()

    /// Обновление текстовых стилей, автоматически вызывается при смене UIContentSizeCategory
    ///
    /// В данном методе необходимо производить настройку шрифтов для поддержки Dynamic Type
    func updateTextStyle(_ previousTraitCollection: UITraitCollection?)
}

public extension ThemeSubscriber {
    /// Технический метод, используется для первоначальной конфигурации элемента и при смене темы в iOS 12
    func _updateAppearance() {
        updateAppearance()
        updateUserInterfaceStyle()
        updateTextStyle((self as? UITraitEnvironment)?.traitCollection)
    }
}

extension ThemeSubscriber where Self: UITraitEnvironment {
    /// Технический метод, для переопределения смены окружения для автоматического вызова методов протокола
    func _traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
                updateUserInterfaceStyle()
            }
        }

        if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
            updateTextStyle(previousTraitCollection)
        }
    }
}
