//
//  Promo.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 26/11/22.
//

import Foundation

// TODO: Create Id from promo & Anime instead of UUID if possible!
final class Promo: Content {
    // MARK: Parameters
    var title: String = ""
    var anime: Anime
    var trailer: Trailer
    
    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case title
        case anime = "entry"
        case trailer
    }
    
    // MARK: Decoding Technique
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title   = try container.decode(String.self, forKey: .title)
        self.anime   = try container.decodeIfPresent(Anime.self, forKey: .anime) ?? Anime()
        self.trailer = try container.decodeIfPresent(Trailer.self, forKey: .trailer) ?? Trailer()
        
        try super.init(from: decoder)
        self.id = anime.id
    }
    
    // MARK: Initializers
    init(title: String, anime: Anime, trailer: Trailer) {
        self.title = title
        self.anime = anime
        self.trailer = trailer
        
        super.init()
    }
    
    override init() {
        self.anime = Anime()
        self.trailer = Trailer()
        super.init()
    }
    
    // Equatable
    static func ==(lhs: Promo, rhs: Promo) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Hashable
    override func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

final class Trailer: Content {
    var url: String = ""
    var image: ContentImage
    var youtubeId: String = ""
    
    enum CodingKeys: String, CodingKey {
        case url
        case image = "images"
    }

    /// # Decoding strategy
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        image = try container.decodeIfPresent(ContentImage.self, forKey: .image) ?? ContentImage()
        youtubeId = url.getYoutubeId() ?? ""
        
        try super.init(from: decoder)
        id = youtubeId
    }
    
    // MARK: Initializers
    override init() {
        self.image = ContentImage()
        super.init()
    }
        
    /// # Hashable
    override func hash(into hasher: inout Hasher) {
        hasher.combine(youtubeId)
    }
    
    /// # Equatable
    static func == (lhs: Trailer, rhs: Trailer) -> Bool {
        let result = lhs.youtubeId == rhs.youtubeId
        return result
    }
}
