//
//  SearchAnime.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 29/05/22.
//

import UIKit

protocol ModelSectionable: Hashable, Equatable {
    var detailFeedSection: DetailFeedSection { get set }
    var feedSection: FeedSection { get set }
    var isLoading: Bool { get set }
    var isLoadMoreItem: Bool { get set }
}

/// Types of show with it's parsed representation.
enum ShowType: String {
    case tv      = "TV Show"
    case special = "TV Special"
    case movie   = "Movie"
    case ova     = "OVA"
    case ona     = "Web Anime (ONA)"
    case music   = "Music"

    init(from raw: String) {
        switch raw.lowercased() {
            case "tv": self = .tv
            case "movie": self = .movie
            case "special": self = .special
            case "ova": self = .ova
            case "ona": self = .ona
            case "music": self = .music
            default: self = .tv
        }
    }
}

struct Anime: Decodable, ModelSectionable {
    // MARK: Parameters
    var uuid = UUID()
    var id: Int
    var titleOrg: String
    var titleEng: String
    var titleKanji: String
    var imageType: AnimeImageType
    var malURL: String
    var synopsis: String
    var episodesCount: Int
    var score: CGFloat
    var rank: Int
    var year: Int
    var members: Int
    var genres: [AnimeGenre]
    var trailer: Trailer
    var showType: ShowType
    var studios: [AnimeStudio]
    var producers: [AnimeProducer]

    var isLoading: Bool = false

    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case id            = "mal_id"
        case titleOrg      = "title"
        case titleEng      = "title_english"
        case titleKanji    = "title_japanese"
        case malURL        = "url"
        case imageType     = "images"
        case synopsis
        case episodesCount = "episodes"
        case score
        case rank
        case year
        case members
        case genres
        case trailer
        case showType      = "type"
        case studios
        case producers
    }

    // MARK: Decoding Technique
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        titleOrg = try container.decode(String.self, forKey: .titleOrg)
        titleEng = try container.decodeIfPresent(String.self, forKey: .titleEng) ?? titleOrg
        titleKanji = try container.decodeIfPresent(String.self, forKey: .titleKanji) ?? titleOrg
        malURL = try container.decodeIfPresent(String.self, forKey: .malURL) ?? ""
        imageType = try container.decode(AnimeImageType.self, forKey: .imageType)
        synopsis = try container.decodeIfPresent(String.self, forKey: .synopsis) ?? ""
        episodesCount = try container.decodeIfPresent(Int.self, forKey: .episodesCount) ?? 0
        score = try container.decodeIfPresent(CGFloat.self, forKey: .score) ?? -1
        rank = try container.decodeIfPresent(Int.self, forKey: .rank) ?? 0
        year = try container.decodeIfPresent(Int.self, forKey: .year) ?? 0
        members = try container.decodeIfPresent(Int.self, forKey: .members) ?? -1
        genres = try container.decodeIfPresent([AnimeGenre].self, forKey: .genres) ?? [AnimeGenre]()
        trailer = try container.decodeIfPresent(Trailer.self, forKey: .trailer) ?? Trailer()
        showType = ShowType(from: try container.decodeIfPresent(String.self, forKey: .showType) ?? "")
        studios = try container.decodeIfPresent([AnimeStudio].self, forKey: .studios) ?? [AnimeStudio]()
        producers = try container.decodeIfPresent([AnimeProducer].self, forKey: .producers) ?? [AnimeProducer]()
    }

    // MARK: Initializers
    init() {
        self.id = 69
        self.titleEng = ""
        self.titleOrg = ""
        self.titleKanji = "BLEACH 千年血戦篇"
        self.imageType = AnimeImageType()
        self.malURL = ""
        self.synopsis = ""
        self.episodesCount = 0
        self.score = 0
        self.rank = 0
        self.year = 0
        self.members = 0
        self.genres = [AnimeGenre]()
        self.trailer = Trailer()
        self.showType = .tv
        self.studios = [AnimeStudio]()
        self.producers = [AnimeProducer]()
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

    // MARK: Additional methods/properties
    var detailFeedSection: DetailFeedSection = .unknown
    var feedSection: FeedSection = .unknown
    var isLoadMoreItem: Bool = false
    
    mutating func setFeedSection(to section: FeedSection) {
        self.feedSection = section
    }
}

struct AnimeImageType: Decodable {
    // MARK: Parameters
    var jpgImage: AnimeImage
    var webpImage: AnimeImage
    var coverImage: UIImage?

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
    enum Resolution {
        case large
        case normal
        case small
    }
    
    // MARK: Parameters
    private var small: String
    private var normal: String
    private var large: String
    
    var imageResolutions: [String: Resolution] = [:]

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
    
    /// Looks up for a non-empty image of a certain **Resolution**, if not found then looks for a lower-res one.
    /// - Returns: Image resource-path.
    func attemptToGetImageByResolution(_ imageResolution: Resolution) -> String {
        switch imageResolution {
            case .large:
                guard !large.isEmpty else { return attemptToGetImageByResolution(.normal) }
                return large
            case .normal:
                guard !normal.isEmpty else { return attemptToGetImageByResolution(.small) }
                return normal
            case .small: return small
        }
    }
}

struct AnimeGenre: Decodable, Hashable {
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

struct AnimeStudio: Decodable {
    // MARK: Parameters
    var id: Int
    var type: String
    var name: String
    var url: String

    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case id = "mal_id"
        case type
        case name
        case url
    }

    // MARK: Decoding Technique
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        self.name = try container.decode(String.self, forKey: .name)
        self.url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
    }

    // MARK: Initializers
    init() {
        self.id = 100
        self.type = "STUDIO_ID"
        self.name = "STUDIO_NAME"
        self.url = "STUDIO_URL"
    }
}

struct AnimeProducer: Decodable {
    // MARK: Parameters
    var id: Int
    var type: String
    var name: String
    var url: String

    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case id = "mal_id"
        case type
        case name
        case url
    }

    // MARK: Decoding Technique
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        self.name = try container.decode(String.self, forKey: .name)
        self.url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
    }

    // MARK: Initializers
    init() {
        self.id = 100
        self.type = "PRODUCER_ID"
        self.name = "PRODUCER__NAME"
        self.url = "PRODUCER_URL"
    }
}

struct SpinnerModel: Decodable, ModelSectionable {
    // MARK: Parameters
    var uuid = UUID()
    var isLoading: Bool = false

    // MARK: Initializers
    init(isLoading: Bool = false) {
        self.isLoading = isLoading
    }

    init(from decoder: Decoder) throws {}

    // MARK: Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }

    // MARK: Equatable
    static func == (lhs: SpinnerModel, rhs: SpinnerModel) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    var detailFeedSection: DetailFeedSection = .spinner
    var feedSection: FeedSection = .unknown
    var isLoadMoreItem: Bool = false
}
