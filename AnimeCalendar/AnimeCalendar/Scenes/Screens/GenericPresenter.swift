//
//  GenericPresenter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 25/11/22.
//

import UIKit

// TODO: - Use it? However some interactors may home more than 1 repository

/// Takes an image after it's recovered from a request
typealias ImageSetting = (UIImage) -> Void

/// Generic presenter to inherit from
///
/// - **R**: Router
/// - **I**: Interactor
class GenericPresenter<R, I: GenericInteractor<GenericRepository>>: NSObject {
    // MARK: State
    private let router: R
    private let interactor: I

    // MARK: Initializers
    init(router: R, interactor: I) {
        self.router = router
        self.interactor = interactor
    }

    // MARK: Methods
    func getImageResource(from path: String, completion: @escaping ImageSetting) {
        interactor.getImageResource(path: path, completion: completion)
    }
}
