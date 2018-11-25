//
//  Artist.swift
//  Get Your Playlist
//
//  Created by Radasia Waltower on 11/24/18.
//  Copyright © 2018 Team 6. All rights reserved.
//

import Foundation
import UIKit

struct ArtistResults : Decodable {
    enum ResultsKeys: String, CodingKey {
        case results
    }
    
    enum ArtistsKeys: String, CodingKey {
        case artists
    }
    
    enum DataKeys: String, CodingKey {
        case data
    }
    
    public init(from decoder: Decoder) throws {
        let results = try decoder.container(keyedBy: ResultsKeys.self)
        let resultsValues = try results.nestedContainer(keyedBy: ArtistsKeys.self, forKey: ResultsKeys.results)
        let dataValues = try resultsValues.nestedContainer(keyedBy: DataKeys.self, forKey: ArtistsKeys.artists)
        artists = try dataValues.decode([Artist].self, forKey: DataKeys.data)
    }
    
    var artists: [Artist]
}

struct Artist: Decodable {
    enum ArtistKeys: String, CodingKey {
        case name
    }
    
    enum AttributesKeys: String, CodingKey {
        case attributes
    }
    
    var name: String
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: AttributesKeys.self)
        let attributesValues = try values.nestedContainer(keyedBy: ArtistKeys.self, forKey: AttributesKeys.attributes)
        name = try attributesValues.decode(String.self, forKey: ArtistKeys.name)
    }
}

