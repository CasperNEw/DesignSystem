//
//  NSAttributedString+.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/08/2022.
//

import UIKit

extension NSAttributedString {
    var isEmpty: Bool {
        return !(length > 0)
    }

    func withSizeChanged(by scaleFactor: CGFloat) -> NSAttributedString {
        let newString = NSMutableAttributedString(attributedString: self)
        newString.beginEditing()
        newString.enumerateAttribute(
            .font,
            in: NSRange(0..<self.length),
            options: .longestEffectiveRangeNotRequired
        ) { (value, range, _) in
            if let font = value as? UIFont {
                newString.removeAttribute(.font, range: range)
                newString.addAttribute(.font, value: font.withSize(font.pointSize * scaleFactor), range: range)
            }
        }
        newString.endEditing()

        return newString
    }

    func calculateHeight(forContainerWidth width: CGFloat) -> CGFloat {
        let rect = self.boundingRect(
            with: .init(width: width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        return ceil(rect.size.height)
    }

    func calculateWidth(forContainerHeight height: CGFloat) -> CGFloat {
        let rect = self.boundingRect(
            with: .init(width: .greatestFiniteMagnitude, height: height),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        return ceil(rect.size.width)
    }
}
