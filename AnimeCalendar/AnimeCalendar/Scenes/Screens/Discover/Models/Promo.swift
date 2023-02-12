//
//  Promo.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 26/11/22.
//

import Foundation

struct PromoResult: Decodable {
    var promos: [Promo]
    
    enum CodingKeys: String, CodingKey {
        case promos = "data"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.promos = try container.decodeIfPresent([Promo].self, forKey: .promos) ?? [Promo]()
    }
}

// TODO: Create Id from promo & Anime instead of UUID if possible!
struct Promo: Decodable, ModelSectionable {
    var id = UUID()
    var title: String
    var anime: Anime
    var trailer: Trailer
    
    var isLoading: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case title
        case anime = "entry"
        case trailer
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.anime = try container.decodeIfPresent(Anime.self, forKey: .anime) ?? Anime()
        self.trailer = try container.decodeIfPresent(Trailer.self, forKey: .trailer) ?? Trailer()
    }
    
    // Equatable
    static func == (lhs: Promo, rhs: Promo) -> Bool {
//        return lhs.anime.id == rhs.anime.id
        return lhs.id == rhs.id
    }
    
    // Hashable
    func hash(into hasher: inout Hasher) {
//        hasher.combine(anime.id)
        hasher.combine(id)
    }
    
    // MARK: Initializers
    init(title: String, anime: Anime, trailer: Trailer) {
        self.title = title
        self.anime = anime
        self.trailer = trailer
    }
    
    init() {
        self.title = "Empty Title"
        self.anime = Anime()
        self.trailer = Trailer()
    }

    var detailFeedSection: DetailFeedSection = .animeTrailer
     
    var feedSection: FeedSection = .animeSeason
}

struct Trailer: Decodable, ModelSectionable {
    let url: String
    let image: AnimeImage
    var youtubeId: String
    
    var isLoading: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case url
        case image = "images"
    }
    
    /// # Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(youtubeId)
//        print("senku [DEBUG] \(String(describing: type(of: self))) - TRAILER ID: \(youtubeId)")
    }
    
    /// # Equatable
    static func == (lhs: Trailer, rhs: Trailer) -> Bool {
        let result = lhs.youtubeId == rhs.youtubeId
//        print("senku [DEBUG] \(String(describing: type(of: self))) - TRAILER EQUATE RESULT - lhs: \(lhs.youtubeId) | rhs: \(rhs.youtubeId) -> \(result)")
        return result
    }
    
    /// # Decoding strategy
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        image = try container.decodeIfPresent(AnimeImage.self, forKey: .image) ?? AnimeImage()
        youtubeId = url.getYoutubeId() ?? ""
    }
    
    // MARK: Initializers
    init(url: String, image: AnimeImage, youtubeId: String) {
        self.url = url
        self.image = image
        self.youtubeId = youtubeId
    }
    
    init() {
        self.url = "Empty URL"
        self.image = AnimeImage()
        self.youtubeId = "e8YBesRKq_U"
    }
    
    // MARK: Addional properties
    var detailFeedSection: DetailFeedSection = .animeTrailer
    var feedSection: FeedSection = .animeSeason
}
