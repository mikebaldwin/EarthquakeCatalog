//
//  Earthquake.swift
//  EarthquakeCatalog
//
//  Created by Michael Baldwin on 1/28/19.
//  Copyright © 2019 mikebaldwin.co. All rights reserved.
//

import Foundation

struct Earthquake {
    let id: String
    let magnitude: Double
    let location: String
    let time: Int
    let updated: Int
    let timeZone: Int
    let url: String
    let detailUrl: String
    let title: String
    let type: String
}

extension Earthquake: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case properties
    }
    
    enum PropertiesCodingKeys: String, CodingKey {
        case magnitude = "mag"
        case location = "place"
        case time
        case updated
        case timeZone = "tz"
        case url
        case detailUrl = "detail"
        case title
        case type
    }
    
    init(from decoder: Decoder) throws {
        let featureValues = try decoder.container(keyedBy: CodingKeys.self)
        id = try featureValues.decode(String.self, forKey: .id)
        
        let propertiesValues = try featureValues.nestedContainer(
            keyedBy: PropertiesCodingKeys.self,
            forKey: .properties
        )
        magnitude = try propertiesValues.decode(Double.self, forKey: .magnitude)
        location = try propertiesValues.decode(String.self, forKey: .location)
        time = try propertiesValues.decode(Int.self, forKey: .time)
        updated = try propertiesValues.decode(Int.self, forKey: .updated)
        timeZone = try propertiesValues.decode(Int.self, forKey: .timeZone)
        url = try propertiesValues.decode(String.self, forKey: .url)
        detailUrl = try propertiesValues.decode(String.self, forKey: .detailUrl)
        title = try propertiesValues.decode(String.self, forKey: .title)
        type = try propertiesValues.decode(String.self, forKey: .type)
    }
}
