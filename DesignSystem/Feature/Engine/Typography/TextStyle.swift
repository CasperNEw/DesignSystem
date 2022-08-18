//
//  TextStyle.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/08/2022.
//

import UIKit

public struct TextStyle: Equatable {

    public var colorToken: ColorToken

    public var typography: Typography

    public var scalable: Bool

    public var maximumScaleFactor: CGFloat

    public var font: UIFont {
        typography.accessibilityFont(scalable: scalable, maximumScaleFactor: maximumScaleFactor)
    }

    public init(
        colorToken: ColorToken,
        typography: Typography,
        scalable: Bool = true,
        maximumScaleFactor: CGFloat = UIContentSizeCategory.maximumScaleFactor
    ) {
        self.colorToken = colorToken
        self.typography = typography
        self.scalable = scalable
        self.maximumScaleFactor = maximumScaleFactor
    }
}


