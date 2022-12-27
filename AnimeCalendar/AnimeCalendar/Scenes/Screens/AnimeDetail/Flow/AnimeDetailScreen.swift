//
//  AnimeDetailScreen.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 26/12/22.
//

import UIKit

final class AnimeDetailScreen: UIViewController, Screen {
    // MARK: State
    private weak var presenter: AnimeDetailPresentable?
    
    // MARK: Initializers
    init(presenter: AnimeDetailPresentable) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("senku [DEBUG] \(String(describing: type(of: self))) - deinted")
    }
}

// MARK: - Life Cycle
extension AnimeDetailScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("senku [DEBUG] \(String(describing: type(of: self))) - viewDidDisappear")
        presenter?.viewDidDissapear()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

private extension AnimeDetailScreen {
    func configureScreen() {
        view.backgroundColor = Color.cream
    }
}


// MARK: Screen
extension AnimeDetailScreen {
    func configureNavigationItems() {}
    
    func configureRightNavigationItems() {}
    
    func configureLeftNavigationItems() {}
}
