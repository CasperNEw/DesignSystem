//
//  Backgroundable.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/07/2022.
//

import UIKit

/// Абстракция имеющая токен цвета фона и имеющая стиль для изменения фона
public protocol Backgroundable {
    var backgroundToken: ColorToken? { get set }
}

public extension Style where T: (Backgroundable & Styleable & UIView) {
    static var background: Style {
        Style(appearance: { $0.backgroundColor = $0.backgroundToken?.color })
    }
}
