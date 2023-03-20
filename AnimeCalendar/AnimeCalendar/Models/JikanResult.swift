//
//  JikanResult.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 11/03/23.
//

import Foundation

struct JikanResult<DataModel: ModelSectionable & Decodable>: Decodable {
    var data: [DataModel] = []
    
    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    init() {
        
    }

    // MARK: Decoding Technique
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decodeIfPresent([DataModel].self, forKey: .data) ?? [DataModel]()
    }
    
    mutating func setFeedSection(to section: FeedSection) {
        data.enumerated().forEach { data[$0.offset].feedSection = section }
    }
    
    mutating func setDetailFeedSection(to section: DetailFeedSection) {
        data.enumerated().forEach { data[$0.offset].detailFeedSection = section }
    }
}
