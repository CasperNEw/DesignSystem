//
//  ImageView.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/07/2022.
//

import UIKit

public final class ImageView: UIImageView, Styleable {
    public var styles: [Style<ImageView>] = []

    public var imageToken: ImageToken? {
        didSet { applyOnce(mark: .imageToken, style: .image) }
    }

    public var tintToken: ColorToken? {
        didSet { applyOnce(mark: .tintToken, style: .tint) }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public override init(image: UIImage?) {
        super.init(image: image)
    }

    public override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
    }

    public init(
        imageToken: ImageToken,
        tintToken: ColorToken? = nil
    ) {
        super.init(frame: .zero)

        self.imageToken = imageToken
        applyOnce(mark: .imageToken, style: .image)

        if tintToken != nil {
            self.tintToken = tintToken
            applyOnce(mark: .tintToken, style: .tint)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension Style where T: ImageView {
    static var image: Style<ImageView> {
        Style<ImageView>(
            layer: {
                $0.image = $0.tintToken != nil
                    ? $0.imageToken?.image?.withRenderingMode(.alwaysTemplate)
                    : $0.imageToken?.image
            }
        )
    }

    static var tint: Style<ImageView> {
        Style<ImageView>(appearance: { if let tintColor = $0.tintToken?.color { $0.tintColor = tintColor } })
    }
}
