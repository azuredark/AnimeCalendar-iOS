//
//  SearchAnime.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 29/05/22.
//

import Foundation

struct AnimeResult: Decodable {
    // MARK: Parameters
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
    // MARK: Parameters
    var uuid = UUID()
    var id: Int
    var titleOrg: String
    var titleEng: String
    var imageType: AnimeImageType
    var malURL: String
    var synopsis: String
    var episodesCount: Int
    var score: CGFloat
    var rank: Int
    var year: Int
    var members: Int
    var genres: [AnimeGenre]

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
        case year
        case members
        case genres
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
        score = try container.decodeIfPresent(CGFloat.self, forKey: .score) ?? -1
        rank = try container.decodeIfPresent(Int.self, forKey: .rank) ?? 0
        year = try container.decodeIfPresent(Int.self, forKey: .year) ?? 0
        members = try container.decodeIfPresent(Int.self, forKey: .members) ?? -1
        genres = try container.decodeIfPresent([AnimeGenre].self, forKey: .genres) ?? [AnimeGenre]()
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
        self.year = 0
        self.members = 0
        self.genres = [AnimeGenre]()
    }

    // MARK: IMPORTANT: UUID is used due to repeated ids in the SeasonAnime & TopAnime sections, as the airing anime could also appear on the top.

    // MARK: Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }

    // MARK: Equatable
    static func == (lhs: Anime, rhs: Anime) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

struct AnimeImageType: Decodable {
    // MARK: Parameters
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
    // MARK: Parameters
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

struct AnimeGenre: Decodable {
    // MARK: Parameters
    var id: Int
    var name: String
    var url: String

    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case id = "mal_id"
        case name
        case url
    }

    // MARK: Decoding Technique
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
    }

    // MARK: Initializers
    init() {
        self.id = 0
        self.name = "DEFAULT_NAME"
        self.url = "DEFAULT_URL"
    }
}
