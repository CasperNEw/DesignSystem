//
//  Label.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/08/2022.
//

import UIKit

public final class Label: UILabel, Styleable {
    public var styles: [Style<Label>] = []

    public var textStyle: TextStyle? {
        didSet {
            let success = once(mark: Label.textStyle) { apply(style: .textStyle) }
            if !success { updateAppearance() }
        }
    }

    public var maximumScaleFactor = UIContentSizeCategory.maximumScaleFactor

    fileprivate lazy var relativeScaleFactor =
        min(traitCollection.preferredContentSizeCategory.scaleFactor, maximumScaleFactor)

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public init(textStyle: TextStyle, text: String? = nil) {
        super.init(frame: .zero)
        self.textStyle = textStyle
        self.text = text
        once(mark: Label.textStyle) { apply(style: .textStyle) }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension Label {
    static let textStyle = "textStyle"
}

public extension Style where T: Label {

    static var attributed: Style<Label> {
        Style<Label>(
            typography: { view, previousTraitCollection in
                view.relativeScaleFactor =
                    min(view.traitCollection.preferredContentSizeCategory.scaleFactor,
                        view.maximumScaleFactor) /
                    min((previousTraitCollection?.preferredContentSizeCategory.scaleFactor ?? 1),
                        view.maximumScaleFactor)
                view.attributedText = view.attributedText?.withSizeChanged(by: view.relativeScaleFactor)
            }
        )
    }

    static var textStyle: Style<Label> {
        Style<Label>(
            appearance: { view in
                view.textColor = view.textStyle?.colorToken.color
            },
            typography: { view, _ in
                view.font = view.textStyle?.font
            }
        )
    }
}
