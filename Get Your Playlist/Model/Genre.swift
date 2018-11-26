//
//  Genre.swift
//  Get Your Playlist
//
//  Created by Radasia Waltower on 11/24/18.
//  Copyright © 2018 Team 6. All rights reserved.
//

import Foundation
import UIKit

struct GenreResults : Decodable {
    
    enum DataKeys: String, CodingKey {
        case data
    }
    
    public init(from decoder: Decoder) throws {
        let results = try decoder.container(keyedBy: DataKeys.self)
        genres = try results.decode([Genre].self, forKey: .data)
    }
    
    var genres: [Genre]
}

struct Genre: Decodable {
    enum GenreKeys: String, CodingKey {
        case name
    }
    
    enum AttributesKeys: String, CodingKey {
        case attributes
    }
    
    var name: String
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: AttributesKeys.self)
        let attributesValues = try values.nestedContainer(keyedBy: GenreKeys.self, forKey: AttributesKeys.attributes)
        name = try attributesValues.decode(String.self, forKey: GenreKeys.name)
    }
}

