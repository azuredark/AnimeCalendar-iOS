//
//  SearchAnime.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 29/05/22.
//

import Foundation

struct AnimeResult: Decodable {
    var data: [Anime] = []

    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case data
    }

    // MARK: Decoding Technique
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decodeIfPresent([Anime].self, forKey: .data) ?? [Anime]()
    }

    // MARK: Initializers
    init() {
        self.data = [Anime]()
    }
}

struct Anime: Decodable, Hashable {
    var id: Int
    var titleOrg: String
    var titleEng: String
    var imageType: AnimeImageType
    var malURL: String
    var synopsis: String
    var episodesCount: Int
    var score: CGFloat
    var rank: Int

    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case id            = "mal_id"
        case titleOrg      = "title"
        case titleEng      = "title_english"
        case malURL        = "url"
        case imageType     = "images"
        case synopsis
        case episodesCount = "episodes"
        case score
        case rank
    }

    // MARK: Decoding Technique
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        titleOrg = try container.decode(String.self, forKey: .titleOrg)
        titleEng = try container.decodeIfPresent(String.self, forKey: .titleEng) ?? titleOrg
        malURL = try container.decodeIfPresent(String.self, forKey: .malURL) ?? ""
        imageType = try container.decode(AnimeImageType.self, forKey: .imageType)
        synopsis = try container.decodeIfPresent(String.self, forKey: .synopsis) ?? ""
        episodesCount = try container.decodeIfPresent(Int.self, forKey: .episodesCount) ?? 0
        score = try container.decodeIfPresent(CGFloat.self, forKey: .score) ?? 0
        rank = try container.decodeIfPresent(Int.self, forKey: .rank) ?? 0
    }

    // MARK: Initializers
    init() {
        self.id = 69
        self.titleEng = ""
        self.titleOrg = ""
        self.imageType = AnimeImageType()
        self.malURL = ""
        self.synopsis = ""
        self.episodesCount = 0
        self.score = 0
        self.rank = 0
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

    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case jpgImage = "jpg"
        case webpImage = "webp"
    }

    // MARK: Decoding Technique
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        jpgImage = try container.decodeIfPresent(AnimeImage.self, forKey: .jpgImage) ?? AnimeImage()
        webpImage = try container.decodeIfPresent(AnimeImage.self, forKey: .webpImage) ?? AnimeImage()
    }

    // MARK: Initializers
    init() {
        self.jpgImage = AnimeImage()
        self.webpImage = AnimeImage()
    }
}

struct AnimeImage: Decodable {
    var small: String
    var normal: String
    var large: String

    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case small = "small_image_url"
        case normal = "image_url"
        case large = "large_image_url"
    }

    // MARK: Decoding Technique
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        small = try container.decodeIfPresent(String.self, forKey: .small) ?? ""
        normal = try container.decodeIfPresent(String.self, forKey: .normal) ?? ""
        large = try container.decodeIfPresent(String.self, forKey: .large) ?? ""
    }

    // MARK: Initializers
    init() {
        self.small = "JPG ERROR"
        self.normal = "JPG ERROR"
        self.large = "JPG ERROR"
    }
}
