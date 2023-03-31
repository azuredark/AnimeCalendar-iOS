//
//  JikanResult.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 11/03/23.
//

import Foundation

final class JikanResult<DataModel: Content>: Decodable {
    var data: [DataModel] = []
    var pagination: JikanPagination
    
    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case data
        case pagination
    }
    
    init(data: [DataModel], pagination: JikanPagination) {
        self.data = data
        self.pagination = pagination
    }
    
    init(data: [DataModel]) {
        self.data = data
        self.pagination = JikanPagination(hasNextPage: false)
    }
    
    init() {
        self.pagination = JikanPagination(hasNextPage: false)
    }
    
    // MARK: Decoding Technique
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decodeIfPresent([DataModel].self, forKey: .data) ?? [DataModel]()
        pagination = try container.decodeIfPresent(JikanPagination.self, forKey: .pagination) ?? JikanPagination(hasNextPage: false)
    }
    
    func setFeedSection(to section: FeedSection) {
        data.enumerated().forEach { data[$0.offset].feedSection = section }
    }
    
    func setDetailFeedSection(to section: DetailFeedSection) {
        data.enumerated().forEach { data[$0.offset].detailFeedSection = section }
    }
}

final class JikanPagination: Decodable {
    // MARK: Parameters
    var hasNextPage: Bool
    var page: Int = 1
    
    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case hasNextPage = "has_next_page"
    }
    
    init(hasNextPage: Bool, page: Int) {
        self.hasNextPage = hasNextPage
        self.page = page
    }
    
    // MARK: Initializers
    init(hasNextPage: Bool) {
        self.hasNextPage = hasNextPage
    }
    
    // MARK: Decoding Technique
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hasNextPage = try container.decodeIfPresent(Bool.self, forKey: .hasNextPage) ?? false
    }
}
