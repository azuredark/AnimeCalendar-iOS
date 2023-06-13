//
//  SearchAnime.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 29/05/22.
//

import UIKit

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

final class Anime: Content {
    // MARK: Parameters
    var uuid = UUID()
    var titleOrg: String = ""
    var titleEng: String = ""
    var titleKanji: String = ""
    var malURL: String = ""
    var synopsis: String = ""
    var episodesCount: Int = 0
    var score: CGFloat = 0
    var rank: Int = 0
    var year: Int = 0
    var members: Int = 0
    var genres: [AnimeGenre] = []
    var trailer: Trailer?
    var showType: ShowType = .tv
    var studios: [AnimeStudio] = []
    var producers: [AnimeProducer] = []

    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
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
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        titleOrg      = try container.decodeIfPresent(String.self, forKey: .titleOrg) ?? ""
        titleEng      = try container.decodeIfPresent(String.self, forKey: .titleEng) ?? titleOrg
        titleKanji    = try container.decodeIfPresent(String.self, forKey: .titleKanji) ?? titleOrg
        malURL        = try container.decodeIfPresent(String.self, forKey: .malURL) ?? ""
        synopsis      = try container.decodeIfPresent(String.self, forKey: .synopsis) ?? ""
        episodesCount = try container.decodeIfPresent(Int.self, forKey: .episodesCount) ?? 0
        score         = try container.decodeIfPresent(CGFloat.self, forKey: .score) ?? 0
        rank          = try container.decodeIfPresent(Int.self, forKey: .rank) ?? 0
        year          = try container.decodeIfPresent(Int.self, forKey: .year) ?? 0
        members       = try container.decodeIfPresent(Int.self, forKey: .members) ?? 0
        genres        = try container.decodeIfPresent([AnimeGenre].self, forKey: .genres) ?? [AnimeGenre]()
        trailer       = try container.decodeIfPresent(Trailer.self, forKey: .trailer) ?? Trailer()
        showType      = ShowType(from: try container.decodeIfPresent(String.self, forKey: .showType) ?? "")
        studios       = try container.decodeIfPresent([AnimeStudio].self, forKey: .studios) ?? [AnimeStudio]()
        producers     = try container.decodeIfPresent([AnimeProducer].self, forKey: .producers) ?? [AnimeProducer]()
        
        try super.init(from: decoder)
    }
    
    override init() {
        super.init()
    }

    // MARK: Initializers

    // MARK: IMPORTANT: UUID is used due to repeated ids in the SeasonAnime & TopAnime sections, as the airing anime could also appear on the top.

    // MARK: Hashable
    override func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }

    // MARK: Equatable
    static func == (lhs: Anime, rhs: Anime) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func setFeedSection(to section: FeedSection) {
        self.feedSection = section
    }
}
