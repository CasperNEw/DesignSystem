//
//  DesignSystemEngine.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/07/2022.
//

import UIKit

public enum DesignSystemEngine {
    /// Стартовая конфигурация Дизайн Системы
    ///
    /// Необходимо произвести до показа окна
    public static func configure(with window: UIWindow?) {
        Swizzler.configure()
        window?.overrideStyle()
    }
}
