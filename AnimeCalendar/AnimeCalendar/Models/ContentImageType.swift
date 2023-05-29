//
//  ContentImageType.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 28/03/23.
//

import UIKit.UIImage

struct ContentImageType: Decodable {
    // MARK: Parameters
    var jpgImage: ContentImage
    var webpImage: ContentImage
    var coverImage: UIImage?
    var themeColor: UIColor?

    var contentId: String?

    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case jpgImage = "jpg"
        case webpImage = "webp"
    }

    // MARK: Decoding Technique
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        var jpgImage = try container.decodeIfPresent(ContentImage.self, forKey: .jpgImage) ?? ContentImage()
        jpgImage.contentId = contentId
        self.jpgImage = jpgImage
        
        var webpImage = try container.decodeIfPresent(ContentImage.self, forKey: .webpImage) ?? ContentImage()
        webpImage.contentId = contentId
        self.webpImage = webpImage
    }

    // MARK: Initializers
    init() {
        self.jpgImage = ContentImage()
        self.webpImage = ContentImage()
    }
}

struct ContentImage: Decodable {
    var contentId: String?
    
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
            case .small:
                if !small.isEmpty { return small }

                if !normal.isEmpty {
                    return attemptToGetImageByResolution(.normal)
                } else if !large.isEmpty {
                    return attemptToGetImageByResolution(.large)
                } else {
                    Logger.log(.info, .error, msg: "Image for \(contentId ?? "") not found on any source.")
                    return ""
                }
        }
    }
}
