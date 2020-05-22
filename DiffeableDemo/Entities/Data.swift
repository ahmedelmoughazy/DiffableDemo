//
//  ResponseData.swift
//  Channels
//
//  Created by Ahmed Refaat on 3/24/20.
//  Copyright © 2020 Ibtikar. All rights reserved.
//

import Foundation

struct ResponseData: Codable {
    
    let movies: [Movie]?
    let categories: [Categorey]?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        movies = try values.decodeIfPresent([Movie].self, forKey: .movies)
        categories = try values.decodeIfPresent([Categorey].self, forKey: .categories)
    }
    
}
