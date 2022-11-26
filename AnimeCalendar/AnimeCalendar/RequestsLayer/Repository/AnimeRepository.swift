//
//  AnimeRepository.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/08/22.
//

import Foundation
import RxSwift

final class AnimeRepository: GenericRepository {
    // MARK: Initiailzers
    override init(_ requestsManager: RequestProtocol) {
        super.init(requestsManager)
    }
    
    // MARK: Methods
    func getAnime(name: String, responsible: RequestResponsibleType = .network) -> Observable<AnimeResult?> {
        return .create { [weak self] observer in
            guard let strongSelf = self else { return Disposables.create() }

            let model = AnimeResult.self
            let requestResponsible: Requestable = strongSelf.requestsManager.getRequestResponsible(.mock)
            
            requestResponsible.makeRequest(model, .anime(.getAnime(name: name))) { result in
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

    func getSeasonAnime(page: Int = 1, responsible: RequestResponsibleType = .network) -> Observable<AnimeResult?> {
        return .create { [weak self] observer in
            guard let strongSelf = self else { return Disposables.create() }
            
            let model = AnimeResult.self
            let requestResponsible: Requestable = strongSelf.requestsManager.getRequestResponsible(.mock)
            
            requestResponsible.makeRequest(model, .season(.getCurrentSeasonAnime(page: page))) { result in
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
    
    func getRecentPromos(page: Int = 1, responsible: RequestResponsibleType = .network) -> Observable<PromoResult?> {
        return .create { [weak self] observer in
            guard let strongSelf = self else { return Disposables.create() }
            
            let model = PromoResult.self
            let requestResponsible: Requestable = strongSelf.requestsManager.getRequestResponsible(.mock)
            
            requestResponsible.makeRequest(model, .promo(.getRecentPromos(page: page))) { result in
                switch result {
                    case .success(let promo):
                        observer.onNext(promo)
                    case .failure(let error):
                        observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
