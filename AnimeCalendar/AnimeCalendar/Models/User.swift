//
//  User.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 28/05/23.
//

import Foundation

struct User: Decodable {
    // MARK: Parameters
    var url: String?
    var username: String = ""
    var images: ContentImageType?

    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case url
        case username
        case images
    }

    // MARK: Decoding Technique
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
        self.username = try container.decodeIfPresent(String.self, forKey: .username) ?? ""
        self.images = try container.decodeIfPresent(ContentImageType.self, forKey: .images)
        
        var imageType = try container.decodeIfPresent(ContentImageType.self, forKey: .images)
        imageType?.contentId = username
        self.images = imageType
    }

    // MARK: Initializers
    init() {}
}
