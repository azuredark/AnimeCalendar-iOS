//
//  SearchAnime.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 29/05/22.
//

import Foundation

struct Anime: Decodable, Hashable {
    var id: Int
    var title: String
    var imageType: AnimeImageType
    var malURL: String
    var synopsis: String

    enum CodingKeys: String, CodingKey {
        case id        = "mal_id"
        case title
        case malURL    = "url"
        case imageType = "images"
        case synopsis
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        malURL = try container.decodeIfPresent(String.self, forKey: .malURL) ?? ""
        imageType = try container.decode(AnimeImageType.self, forKey: .imageType)
        synopsis = try container.decodeIfPresent(String.self, forKey: .synopsis) ?? ""
    }
  
    init() {
        self.id = 69
        self.title = ""
        self.imageType = AnimeImageType()
        self.malURL = ""
        self.synopsis = ""
    }
    
    // MARK: Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // MARK: Equatable
    static func == (lhs: Anime, rhs: Anime) -> Bool {
        return lhs.id == rhs.id
    }
}

struct AnimeImageType: Decodable {
    var jpgImage: AnimeImage
    var webpImage: AnimeImage

    enum CodingKeys: String, CodingKey {
        case jpgImage = "jpg"
        case webpImage = "webp"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        jpgImage = try container.decodeIfPresent(AnimeImage.self, forKey: .jpgImage) ?? AnimeImage()
        webpImage = try container.decodeIfPresent(AnimeImage.self, forKey: .webpImage) ?? AnimeImage()
    }
    
    init() {
        self.jpgImage = AnimeImage()
        self.webpImage = AnimeImage()
    }
}

struct AnimeImage: Decodable {
    var small: String
    var normal: String
    var large: String

    enum CodingKeys: String, CodingKey {
        case small = "small_image_url"
        case normal = "image_url"
        case large = "large_image_url"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        small = try container.decodeIfPresent(String.self, forKey: .small) ?? ""
        normal = try container.decodeIfPresent(String.self, forKey: .normal) ?? ""
        large = try container.decodeIfPresent(String.self, forKey: .large) ?? ""
    }

    init() {
        self.small = "JPG ERROR"
        self.normal = "JPG ERROR"
        self.large = "JPG ERROR"
    }
}

struct AnimeResult: Decodable {
    // If decoding fails, this might be why lol
    var data: [Anime] = []

    enum CodingKeys: String, CodingKey {
        case data
    }
}
