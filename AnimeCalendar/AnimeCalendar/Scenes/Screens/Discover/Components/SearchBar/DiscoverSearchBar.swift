//
//  DiscoverSearchBar.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 13/11/22.
//

import UIKit
import RxSwift
import RxCocoa

final class DiscoverSearchBar: UIView {
    // MARK: State
    private lazy var fullContainer: UIView = {
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)
        return container
    }()
        
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapSearch), for: .touchUpInside)
        fullContainer.addSubview(button)
        return button
    }()
    
    private lazy var textFieldContainer: UIView = {
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        fullContainer.addSubview(container)
        return container
    }()
     
    private lazy var textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textFieldContainer.addSubview(textField)
        return textField
    }()
    
    lazy var onTapAction: Observable<Void> = {
        searchButton.rx.tap.asObservable()
    }()
    
    private var hasShadowAndRadius: Bool = false
    
    /// # Presenter
    private weak var presenter: DiscoverPresentable?

    // MARK: Initializers
    init(presenter: DiscoverPresentable?) {
        super.init(frame: .zero)
        self.presenter = presenter
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureSearchButtonShadow()
    }
}

private extension DiscoverSearchBar {
    func configureUI() {
        configureContainer()
        configureSearchButton()
        configureTextFieldContainer()
        configureTextField()
    }
}

private extension DiscoverSearchBar {
    func configureContainer() {
        fullContainer.backgroundColor = .clear
        NSLayoutConstraint.activate([
            fullContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            fullContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            fullContainer.topAnchor.constraint(equalTo: topAnchor),
            fullContainer.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configureSearchButton() {
        // https://useyourloaf.com/blog/button-configuration-in-ios-15/
        
        if #available(iOS 15.0, *) {
            var buttonConfig: UIButton.Configuration = .tinted()
            buttonConfig.baseBackgroundColor = .clear
            buttonConfig.baseForegroundColor = Color.white
            searchButton.configurationUpdateHandler = { button in
                button.backgroundColor = button.isHighlighted ? Color.pink.withAlphaComponent(0.6) : Color.pink
                buttonConfig.baseForegroundColor = button.isHighlighted ? Color.white.withAlphaComponent(0.4) : Color.white
            }
            
            searchButton.configuration = buttonConfig
        } else {
            // Fallback on earlier versions
            searchButton.tintColor = Color.white
            searchButton.backgroundColor = Color.pink
        }
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 19, weight: .bold, scale: .small)
        let image = UIImage(systemName: "magnifyingglass", withConfiguration: imageConfig)!
        searchButton.setImage(image, for: .normal)
        
        let side: CGFloat = 35.0
        NSLayoutConstraint.activate([
            searchButton.trailingAnchor.constraint(equalTo: fullContainer.trailingAnchor),
            searchButton.centerYAnchor.constraint(equalTo: fullContainer.centerYAnchor),
            searchButton.heightAnchor.constraint(equalToConstant: side),
            searchButton.widthAnchor.constraint(equalToConstant: side)
        ])
    }
    
    func configureTextFieldContainer() {
        textFieldContainer.backgroundColor = Color.white
        textFieldContainer.addCornerRadius(radius: 5.0)
        
        let rightInset: CGFloat = 10.0
        NSLayoutConstraint.activate([
            textFieldContainer.leadingAnchor.constraint(equalTo: fullContainer.leadingAnchor),
            textFieldContainer.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -rightInset),
            textFieldContainer.topAnchor.constraint(equalTo: fullContainer.topAnchor),
            textFieldContainer.bottomAnchor.constraint(equalTo: fullContainer.bottomAnchor)
        ])
    }
    
    func configureTextField() {
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Color.lightGray
        ]
        
        textField.attributedPlaceholder = NSAttributedString(string: "shingeki no kyojin, dr. stone",
                                                             attributes: placeholderAttributes)
        textField.textColor = Color.cobalt
        textField.font = .boldSystemFont(ofSize: 18)
        textField.overrideUserInterfaceStyle = .light
        
        let xInset: CGFloat = 10.0
        let yInset: CGFloat = 5.0
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor, constant: xInset),
            textField.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor, constant: -xInset),
            textField.topAnchor.constraint(equalTo: textFieldContainer.topAnchor, constant: yInset),
            textField.bottomAnchor.constraint(equalTo: textFieldContainer.bottomAnchor, constant: -yInset)
        ])
    }
}

private extension DiscoverSearchBar {
    @objc func didTapSearch(_ button: UIButton) {
        print("senku [DEBUG] \(String(describing: type(of: self))) - didTapSearch")
        presenter?.didTapSearchButton()
    }
}

private extension DiscoverSearchBar {
    func configureSearchButtonShadow() {
        if !hasShadowAndRadius {
            let shadow = ShadowBuilder().getTemplate(type: .full)
                .with(color: Color.pink)
                .with(cornerRadius: 10.0)
                .build()
            searchButton.addButtonShadow(shadow: shadow)
            hasShadowAndRadius = true
        }
    }
}
