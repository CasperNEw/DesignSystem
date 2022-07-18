//
//  ViewController.swift
//  DesignSystem
//
//  Created by Дмитрий Константинов on 18/07/2022.
//

import UIKit

open class ViewController: UIViewController {

    public var contentView: BackgroundView? {
        return view as? BackgroundView
    }

    open override func loadView() {
        let view = BackgroundView(backgroundToken: .background)
        self.view = view
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
