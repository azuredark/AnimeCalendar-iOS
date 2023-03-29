//
//  Content.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 28/03/23.
//

import Foundation

protocol JikanContent {
    var id: String { get }
}

class Content: Decodable {
    // MARK: Parameters
    var imageType: AnimeImageType?

    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case imageType = "images"
    }

    // MARK: Decoding Technique
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.imageType = try container.decodeIfPresent(AnimeImageType.self, forKey: .imageType)
    }

    // MARK: Initializers
    init() {}
}
