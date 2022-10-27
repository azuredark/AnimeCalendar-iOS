//
//  AnimeRepository.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/08/22.
//

import Foundation
import RxSwift

final class AnimeRepository {
    // Properties
    private var requestsManager: RequestProtocol
    private var disposeBag = DisposeBag()

    // Initializers
    init(_ requestsManager: RequestProtocol) {
        self.requestsManager = requestsManager
    }
}

extension AnimeRepository {
    func getAnime(name: String) -> Observable<JikanAnimeResult?> {
        return .create { [weak self] observer in
            guard let strongSelf = self else { return Disposables.create() }
            strongSelf.requestsManager.network.makeRequest(JikanAnimeResult.self, .anime(.getAnime(name: name))) { result in
                switch result {
                    case .success(let anime):
                        observer.onNext(anime)
                    case .failure(let error):
                        observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
