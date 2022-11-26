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
struct Promo: Decodable, Hashable {
    var id = UUID()
    var title: String
    var anime: Anime
    var trailer: Trailer
    
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
}

struct Trailer: Decodable {
    let url: String
    let image: AnimeImage
    
    enum CodingKeys: String, CodingKey {
        case url
        case image = "images"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        self.image = try container.decodeIfPresent(AnimeImage.self, forKey: .image) ?? AnimeImage()
    }
    
    // MARK: Initializers
    init(url: String, image: AnimeImage) {
        self.url = url
        self.image = image
    }
    
    init() {
        self.url = "Empty URL"
        self.image = AnimeImage()
    }
}
