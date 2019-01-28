//
//  EarthquakeCatalogApi.swift
//  EarthquakeCatalog
//
//  Created by Michael Baldwin on 1/28/19.
//  Copyright © 2019 mikebaldwin.co. All rights reserved.
//

import Foundation

fileprivate struct RootData: Decodable {
    let earthquakes: [Earthquake]
    
    enum CodingKeys: String, CodingKey {
        case features
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        earthquakes = try values.decode([Earthquake].self, forKey: .features)
    }
}

struct EarthquakeCatalog {
    
    var baseUrl = URL(string: "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson")
    
    func earthquakesFromLast30Days(success: @escaping ([Earthquake]) -> Void,
                                   failure: @escaping (Error) -> Void) {
        // Assemble request
        guard let url = baseUrl else {
            fatalError("Programmer error: Couldn't create URL")
        }
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { data, _, error in
            if let error = error {
                failure(error)
            }
            if let data = data {
                do {
                    let earthquakes = try JSONDecoder()
                        .decode(RootData.self, from: data)
                        .earthquakes
                        .filter { $0.type == "earthquake" }
                    success(earthquakes)
                } catch {
                    failure(error)
                }
            }
        })
        // Send request
        dataTask.resume()
    }

}
