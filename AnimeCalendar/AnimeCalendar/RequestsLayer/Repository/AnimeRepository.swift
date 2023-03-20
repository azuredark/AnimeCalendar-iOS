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
    func getAnime(name: String, responsible: RequestResponsibleType = .network) -> Single<JikanResult<Anime>?> {
        return .create { [weak self] (single) in
            guard let strongSelf = self else { return Disposables.create() }

            let model = JikanResult<Anime>.self
            let requestResponsible: Requestable = strongSelf.requestsManager.getRequestResponsible(responsible)
            
            requestResponsible.makeRequest(model, .anime(.getAnime(name: name))) { result in
                switch result {
                    case .success(let anime):
                        single(.success(anime))
                    case .failure(_):
                        single(.success(nil))
                }
            }
            return Disposables.create()
        }
    }

    func getSeasonAnime(page: Int = 1, responsible: RequestResponsibleType = .network) -> Single<JikanResult<Anime>?> {
        return .create { [weak self] (single) in
            guard let strongSelf = self else { return Disposables.create() }
            
            let model = JikanResult<Anime>.self
            let requestResponsible: Requestable = strongSelf.requestsManager.getRequestResponsible(responsible)
            
            requestResponsible.makeRequest(model, .season(.getCurrentSeasonAnime(page: page))) { result in
                switch result {
                    case .success(var anime):
                        anime?.setFeedSection(to: .animeSeason)
                        single(.success(anime))
                    case .failure(_):
                        single(.success(nil))
                }
            }
            return Disposables.create()
        }
    }
    
    func getRecentPromos(page: Int = 1, responsible: RequestResponsibleType = .network) -> Single<JikanResult<Promo>?> {
        return .create { [weak self] (single) in
            guard let strongSelf = self else { return Disposables.create() }
            
            let model = JikanResult<Promo>.self
            let requestResponsible: Requestable = strongSelf.requestsManager.getRequestResponsible(responsible)
            
            requestResponsible.makeRequest(model, .promo(.getRecentPromos(page: page))) { result in
                switch result {
                    case .success(var promo):
                        promo?.setFeedSection(to: .animePromos)
                        single(.success(promo))
                    case .failure(_):
                        single(.success(nil))
                }
            }
            return Disposables.create()
        }
    }
    
    func getTopAnime(by order: AnimeOrderType, page: Int = 1, responsible: RequestResponsibleType = .network) -> Single<JikanResult<Anime>?> {
        return .create { [weak self] (single) in
            guard let strongSelf = self else { return Disposables.create() }
            
            let model = JikanResult<Anime>.self
            let requestResponsible: Requestable = strongSelf.requestsManager.getRequestResponsible(responsible)
            
            requestResponsible.makeRequest(model, .top(.getTopAnime(orderBy: order, page: page))) { result in
                switch result {
                    case .success(var anime):
                        anime?.setFeedSection(to: .animeTop)
                        single(.success(anime))
                    case .failure(_):
                        single(.success(nil))
                }
            }
            return Disposables.create()
        }
    }
    
    func getAnimeCharacters(animeId: Int, responsible: RequestResponsibleType = .network) -> Single<CharacterData?> {
        return .create { [weak self] (single) in
            guard let strongSelf = self else { return Disposables.create() }
            
            let model = CharacterData.self
            let requestResponsible: Requestable = strongSelf.requestsManager.getRequestResponsible(responsible)
            
            requestResponsible.makeRequest(model, .anime(.getCharacters(animeId: animeId))) { result in
                switch result {
                    case .success(var characterData):
                        characterData?.animeId = animeId
                        single(.success(characterData))
                    case .failure(_):
                        single(.success(nil))
                }
            }
            
            return Disposables.create()
        }
    }
}
