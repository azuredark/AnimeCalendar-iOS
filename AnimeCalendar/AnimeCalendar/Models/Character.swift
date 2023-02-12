//
//  Character.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 3/02/23.
//

import Foundation

enum CharacterRole: String {
    case main = "Main"
    case secondary = "Secondary"

    init(_ value: String) {
        switch value.lowercased() {
            case "main": self = .main
            default: self = .secondary
        }
    }
}

enum Language: String {
    case japanese   = "Japanese"
    case english    = "English"
    case portuguese = "Portuguese"
    case french     = "French"
    case spanish    = "Spanish"
    case german     = "German"
    case other      = "Unknown"

    init(_ value: String) {
        switch value.lowercased() {
            case "japanese": self = .japanese
            case "english": self = .english
            case "french": self = .french
            case "spanish": self = .spanish
            case "german": self = .german
            default: self = .other
        }

        if value.localizedStandardContains("portuguese") {
            self = .portuguese
        }
    }
}

struct CharacterData: ModelSectionable, Decodable {
    // MARK: Parameters
    let data: [CharacterInfo]
    let uuid = UUID()
    var animeId: Int?

    var isLoading: Bool = false

    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case data
    }

    // MARK: Decoding Technique
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decodeIfPresent([CharacterInfo].self, forKey: .data) ?? []
    }

    // MARK: Initializers
    init(isLoading: Bool = false, animeId: Int? = nil) {
        self.data = []
        self.isLoading = isLoading
        if let animeId = animeId { self.animeId = animeId }
    }

    // MARK: Hashable
    func hash(into hasher: inout Hasher) {
        guard let animeId = animeId else {
            return hasher.combine(uuid)
        }

        return hasher.combine(animeId)
    }

    // MARK: Equatable
    static func == (lhs: CharacterData, rhs: CharacterData) -> Bool {
        guard let lhsAnimeId = lhs.animeId, let rhsAnimeId = rhs.animeId else {
            return lhs.uuid == rhs.uuid
        }

        return lhsAnimeId == rhsAnimeId
    }

    var detailFeedSection: DetailFeedSection = .animeCharacters
    var feedSection: FeedSection = .animePromos
}

struct CharacterInfo: Decodable, ModelSectionable {
    // MARK: Parameters
    var character: Character
    var role: CharacterRole
    var voiceActors: [PersonInfo]?
    var isLoading: Bool = false

    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case character
        case role
        case voiceActors = "voice_actors"
    }

    // MARK: Decoding Technique
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.character = try container.decodeIfPresent(Character.self, forKey: .character) ?? Character()
        self.role = CharacterRole(try container.decodeIfPresent(String.self, forKey: .role) ?? "main")
        self.voiceActors = try container.decodeIfPresent([PersonInfo].self, forKey: .voiceActors)
    }

    // MARK: Initializers
    init() {
        self.character = Character()
        self.role = .main
        self.voiceActors = []
    }

    // MARK: Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(character.id)
    }

    // MARK: Equatable
    static func == (lhs: CharacterInfo, rhs: CharacterInfo) -> Bool {
        return lhs.character.id == rhs.character.id
    }

    var detailFeedSection: DetailFeedSection = .animeCharacters
    var feedSection: FeedSection = .animePromos
}

struct Character: Decodable {
    // MARK: Parameters
    var id: Int
    var url: String?
    var images: AnimeImageType?
    var name: String

    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case id = "mal_id"
        case url
        case images
        case name
    }

    // MARK: Decoding Technique
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
        self.images = try container.decodeIfPresent(AnimeImageType.self, forKey: .images)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? "LEZZ DO IT"
    }

    // MARK: Initializers
    init() {
        self.id = 69
        self.url = nil
        self.images = AnimeImageType()
        self.name = "LEZZ DO IT"
    }
}

struct PersonInfo: Decodable {
    // MARK: Parameters
    var person: Person?
    var language: Language

    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case person
        case language
    }

    // MARK: Decoding Technique
    init(from decoder: Decoder) throws {
        let decoder = try decoder.container(keyedBy: CodingKeys.self)
        self.person = try decoder.decodeIfPresent(Person.self, forKey: .person)
        self.language = Language(try decoder.decodeIfPresent(String.self, forKey: .language) ?? "japanese")
    }

    // MARK: Initializers
    init() {
        self.person = Person()
        self.language = .japanese
    }
}

struct Person: Decodable {
    // MARK: Parameters
    var id: Int
    var url: String?
    var images: AnimeImageType?
    var name: String

    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case id = "mal_id"
        case url
        case images
        case name
    }

    // MARK: Decoding Technique
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
        self.images = try container.decodeIfPresent(AnimeImageType.self, forKey: .images)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? "LEZZ DO IT"
    }

    // MARK: Initializers
    init() {
        self.id = 69
        self.url = nil
        self.images = AnimeImageType()
        self.name = "LEZZ DO IT"
    }
}
