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
    var searchAnimeResult: Driver<[JikanAnime]> { get }
    func getImageObservable(from path: String) -> Observable<UIImage?>
    func getCoverImage(path: String, completion: @escaping (UIImage) -> Void)
}

final class NewAnimeInteractor {
    // MARK: State
    private let animeRepository: AnimeRepository

    /// # Observables
    private let inputSearchAnimeObservable = PublishSubject<String>()
    private let searchResultAnimeObservable = PublishSubject<[JikanAnime]>()

    private let disposeBag = DisposeBag()

    // MARK: Initializers
    init(animeRepository: AnimeRepository) {
        self.animeRepository = animeRepository
        setup()
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
            .flatMapLatest { [weak self] text -> Observable<[JikanAnime]> in
                guard let self = self else { return Observable.just(JikanAnimeResult().data) }
                print("senku [DEBUG] \(String(describing: type(of: self))) - text: \(text)")
                return self.animeRepository.getAnime(name: text).compactMap { $0?.data }
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

    var searchAnimeResult: Driver<[JikanAnime]> {
        searchResultAnimeObservable.asDriver(onErrorJustReturn: [])
    }

    func getImageObservable(from path: String) -> Observable<UIImage?> {
        return animeRepository.getResource(in: .newAnimeScreen, path: path)
            .flatMapLatest { data -> Observable<UIImage?> in
                .create { observable in
                    observable.onNext(UIImage(data: data))
                    observable.onCompleted()
                    return Disposables.create()
                }
            }
    }

    func getCoverImage(path: String, completion: @escaping (UIImage) -> Void) {
        animeRepository.getResourceV2(in: .newAnimeScreen, path: path) { data in
            if let data = data {
                completion(UIImage(data: data) ?? UIImage(named: "new-anime-item-drstone")!)
                return
            }
            completion(UIImage(named: "new-anime-item-drstone")!)
        }
    }
}
