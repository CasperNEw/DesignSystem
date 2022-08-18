//
//  Typography.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/08/2022.
//

import UIKit

public enum Typography {
    // MARK: - Texts
    case textsBodyRegular

    // MARK: - Cells
    case cellsTitle

    // MARK: - Buttons
    case buttonsMain
}

// MARK: - Font
extension Typography {

    public func accessibilityFont(
        scalable: Bool = true,
        maximumScaleFactor: CGFloat = UIContentSizeCategory.maximumScaleFactor
    ) -> UIFont {
        return font.accessibilityFont(scalable: scalable, maximumScaleFactor: maximumScaleFactor)
    }

    private var font: UIFont {
        switch self {
        // MARK: - Texts
        case .textsBodyRegular: return UIFont.Texts.bodyRegular

        // MARK: - Cells
        case .cellsTitle: return UIFont.Cells.title

        // MARK: - Buttons
        case .buttonsMain: return UIFont.Buttons.main
        }
    }
}
