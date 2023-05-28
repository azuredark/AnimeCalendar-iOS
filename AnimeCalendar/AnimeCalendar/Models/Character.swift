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

final class CharacterInfo: Content {
    // MARK: Parameters
    var character: Character
    var role: CharacterRole = .main
    var voiceActors: [PersonInfo]?

    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case character
        case role
        case voiceActors = "voice_actors"
    }

    // MARK: Decoding Technique
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.character   = try container.decodeIfPresent(Character.self, forKey: .character) ?? Character()
        self.role        = CharacterRole(try container.decodeIfPresent(String.self, forKey: .role) ?? "main")
        self.voiceActors = try container.decodeIfPresent([PersonInfo].self, forKey: .voiceActors)
        
        try super.init(from: decoder)
    }

    // MARK: Initializers
    override init() {
        self.character = Character()
        super.init()
    }

    // MARK: Hashable
    override func hash(into hasher: inout Hasher) {
        hasher.combine(character.id)
    }

    // MARK: Equatable
    static func == (lhs: CharacterInfo, rhs: CharacterInfo) -> Bool {
        return lhs.character.id == rhs.character.id
    }
}

final class Character: Content {
    // MARK: Parameters
    var url: String?
    var name: String = ""

    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case url
        case name
    }

    // MARK: Decoding Technique
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url  = try container.decodeIfPresent(String.self, forKey: .url)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? "LEZZ DO IT"
        
        try super.init(from: decoder)
    }

    // MARK: Initializers
    override init() {
        super.init()
    }
}

final class PersonInfo: Decodable {
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
        
        self.person   = try decoder.decodeIfPresent(Person.self, forKey: .person)
        self.language = Language(try decoder.decodeIfPresent(String.self, forKey: .language) ?? "japanese")
    }

    // MARK: Initializers
    init() {
        self.person = Person()
        self.language = .japanese
    }
}

final class Person: Content {
    // MARK: Parameters
    var url: String?
    var name: String = ""

    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case id = "mal_id"
        case url
        case images
        case name
    }

    // MARK: Decoding Technique
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url  = try container.decodeIfPresent(String.self, forKey: .url)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? "LEZZ DO IT"
        
        try super.init(from: decoder)
    }
    
    override init() {
        super.init()
    }
}
