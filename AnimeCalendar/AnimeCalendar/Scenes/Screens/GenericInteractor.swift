//
//  GenericInteractor.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 25/11/22.
//

import UIKit

/// Contains common interactor methods such fetching images
class GenericInteractor<T: GenericRepository> {
    // MARK: State
    let repository: T
    let screen: ScreenType

    // MARK: Initializers
    init(repository: T, screen: ScreenType) {
        self.repository = repository
        self.screen = screen
    }

    // MARK: Methods
    func getImageResource(path: String, completion: @escaping (UIImage) -> Void) {
        repository.getResource(in: screen, path: path) { data in
            if let data = data {
                completion(UIImage(data: data) ?? UIImage(named: "new-anime-item-drstone")!)
                return
            }
            completion(UIImage(named: "new-anime-item-drstone")!)
        }
    }
}
