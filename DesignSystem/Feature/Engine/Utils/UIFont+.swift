//
//  UIFont+.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/08/2022.
//

import UIKit

public extension UIFont {
    func accessibilityFont(scalable: Bool, maximumScaleFactor: CGFloat) -> UIFont {
        guard scalable else { return self }

        let scaleFactor = min(UIApplication.shared.preferredContentSizeCategory.scaleFactor, maximumScaleFactor)
        var scaledSize = pointSize * scaleFactor
        scaledSize.round(.down)

        return withSize(scaledSize)
    }
}
