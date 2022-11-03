//
//  HomeInteractor.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/10/22.
//

import Foundation
import RxSwift
import RxCocoa

/**
 HomeInterective, interactor's exposed methods
 */
protocol HomeInteractive {
    func updateUserAnimes(name: String)
    var animes: Driver<[JikanAnime]> { get }
}

final class HomeInteractor {
    // MARK: State
    private let animeRepository: AnimeRepository
    
    /// # Observables
    /// This should eventaully have an initial value from user's local storage
    private let animesObservable = BehaviorRelay<[JikanAnime]>(value: [])
    private let disposeBag = DisposeBag()

    // MARK: Initializers
    /// This should come from dependency injection (Swinject candidate)
    init(animeRepository: AnimeRepository) {
        self.animeRepository = animeRepository
    }
}

extension HomeInteractor: HomeInteractive {
    var animes: Driver<[JikanAnime]> {
        return animesObservable
            .skip(1)
            .asDriver(onErrorJustReturn: [])
    }

    func updateUserAnimes(name: String) {
        animeRepository.getAnime(name: name)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] result in
                guard let strongSelf = self else { return }
                let animes: [JikanAnime] = result.data
                strongSelf.animesObservable.accept(animes)
            }).disposed(by: disposeBag)
    }
}
