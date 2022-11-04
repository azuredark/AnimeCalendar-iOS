//
//  SearchAnime.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 29/05/22.
//

import Foundation

protocol Model {}

struct Anime: Decodable, Model {
    var name: String
    var cover: String
    var rating: Float
    var episodesCount: Int
    var year: Int
    var synopsis: String
    var genres: [AnimeGenre]
    var onAir: Bool

    init(name: String, cover: String, rating: Float, episodesCount: Int, year: Int, synopsis: String, genres: [AnimeGenre], onAir: Bool) {
        self.name = name
        self.cover = cover
        self.rating = rating
        self.episodesCount = episodesCount
        self.year = year
        self.synopsis = synopsis
        self.genres = genres
        self.onAir = onAir
    }

    // Default anime
    init() {
        self.init(
            name: "Komi can't communicate",
            cover: "new-anime-item-komicantcommunicate",
            rating: 8.5,
            episodesCount: 12,
            year: 2021,
            synopsis: "Hitohito Tadano is an ordinary boy who heads into his first day of high school with a clear plan: to avoid trouble and do his best to blend in with others. Unfortunately, he fails right away when he takes the seat beside the school's madonna—Shouko Komi. His peers now recognize him as someone to eliminate for a chance to sit next to the most beautiful girl in class",
            genres: [
                AnimeGenre(name: "Comedy"),
                AnimeGenre(name: "Romantic"),
                AnimeGenre(name: "School")
            ],
            onAir: false
        )
    }

    init(name: String, cover: String, onAir: Bool = false) {
        self.init(
            name: name,
            cover: cover,
            rating: 8.5,
            episodesCount: 12,
            year: 2021,
            synopsis: "Hitohito Tadano is an ordinary boy who heads into his first day of high school with a clear plan: to avoid trouble and do his best to blend in with others. Unfortunately, he fails right away when he takes the seat beside the school's madonna—Shouko Komi. His peers now recognize him as someone to eliminate for a chance to sit next to the most beautiful girl in class",
            genres: [
                AnimeGenre(name: "Comedy"),
                AnimeGenre(name: "Romantic"),
                AnimeGenre(name: "School")
            ],
            onAir: onAir
        )
    }
}

struct JikanAnime: Decodable {
    var title: String
    var imageType: AnimeImageType
    var malURL: String
    var synopsis: String

    enum CodingKeys: String, CodingKey {
        case title, synopsis
        case malURL = "url"
        case imageType = "images"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        malURL = try container.decodeIfPresent(String.self, forKey: .malURL) ?? ""
        imageType = try container.decode(AnimeImageType.self, forKey: .imageType)
        synopsis = try container.decodeIfPresent(String.self, forKey: .synopsis) ?? ""
    }
    
    init() {
        self.title = ""
        self.imageType = AnimeImageType()
        self.malURL = ""
        self.synopsis = ""
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

struct JikanAnimeResult: Decodable {
    // If decoding fails, this might be why lol
    var data: [JikanAnime] = []

    enum CodingKeys: String, CodingKey {
        case data
    }
}
