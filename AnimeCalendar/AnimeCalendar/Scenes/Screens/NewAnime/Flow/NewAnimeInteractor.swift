//
//  NewAnimeInteractor.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/10/22.
//

import Foundation
import RxSwift
import RxCocoa

protocol NewAnimeInteractive {
    var searchInput: PublishSubject<String> { get }
    var searchAnimeResult: Driver<[Anime]> { get }
    func getImageResource(path: String, completion: @escaping ImageSetting)
}

final class NewAnimeInteractor: GenericInteractor<AnimeRepository> {
    // MARK: State
    /// # Observables
    private let inputSearchAnimeObservable = PublishSubject<String>()
    private let searchResultAnimeObservable = PublishSubject<[Anime]>()

    private let disposeBag = DisposeBag()
    
    init(repository: AnimeRepository) {
        super.init(repository: repository, screen: .newAnimeScreen)
        setupBindings()
    }

    private func setup() {
        setupBindings()
    }
}

private extension NewAnimeInteractor {
    func setupBindings() {
        bindSearchObservable()
    }

    /// Listens to valid user input, transforms it into an JikanAnime observable and binds to it.
    func bindSearchObservable() {
        inputSearchAnimeObservable
            .flatMapLatest { [weak self] text -> Observable<[Anime]> in
                guard let self = self else { return Observable.just(AnimeResult().data) }
                print("senku [DEBUG] \(String(describing: type(of: self))) - text: \(text)")
                return self.repository.getAnime(name: text).compactMap { $0?.data }
            }
            .bind(to: searchResultAnimeObservable)
            .disposed(by: disposeBag)
    }
}

// MARK: - Presenter data source
extension NewAnimeInteractor: NewAnimeInteractive {
    var searchInput: PublishSubject<String> {
        inputSearchAnimeObservable
    }

    var searchAnimeResult: Driver<[Anime]> {
        searchResultAnimeObservable.asDriver(onErrorJustReturn: [])
    }
}
