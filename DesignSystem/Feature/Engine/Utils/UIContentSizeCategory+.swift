//
//  UIContentSizeCategory+.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/08/2022.
//

import UIKit

public extension UIContentSizeCategory {

    static let maximumScaleFactor: CGFloat = 1.3

    var scaleFactor: CGFloat {
        switch self {
        case .extraSmall, .small, .medium, .large, .unspecified:
            return 1
        case .extraLarge:
            return 1.1
        case .extraExtraLarge:
            return 1.2
        case .extraExtraExtraLarge, .accessibilityMedium, .accessibilityLarge,
             .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            guard !UIDevice.isIPhone5 else {
                return 1.2
            }
            return UIContentSizeCategory.maximumScaleFactor
        default:
            return 1
        }
    }
}
