//
//  HomeDateComponent.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 1/05/22.
//

import UIKit

final class HomeDateComponent: UIViewController, ScreenComponent {
    /// # Outlets
    @IBOutlet private weak var currentDateView: UIView!
    @IBOutlet private weak var currentDateLabel: UILabel!
    @IBOutlet private weak var dayBeforeView: UIView!
    @IBOutlet private weak var dayBeforeImage: UIImageView!
    @IBOutlet private weak var dayAfterView: UIView!
    @IBOutlet private weak var dayAfterImage: UIImageView!

    init() {
        super.init(nibName: Xibs.homeDateComponentView, bundle: Bundle.main)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeDateComponent {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureComponent()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureCurrentDateViewShadow()
    }
}

extension HomeDateComponent: Component {
    func configureComponent() {
        configureView()
    }

    func configureView() {
        configureSubviews()
    }

    func configureSubviews() {}
}

private extension HomeDateComponent {
    func configureCurrentDateViewShadow() {
        let shadow = ShadowBuilder().getTemplate(type: .bottom)
            .with(color: Color.pink)
            .with(cornerRadius: 15.0)
            .with(opacity: 1.0)
            .build()
        currentDateView.addShadow(with: shadow)
    }
}
