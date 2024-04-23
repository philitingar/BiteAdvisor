//
//  Restaurants.swift
//  BiteAdvisor
//
//  Created by Timea Bartha on 21/4/24.
//

import Foundation

struct YelpResponse: Codable {
    let businesses: [Business]
    let total: Int
}

struct Business: Codable {
    let id, alias, name: String
    let imageURL: String
    let url: String
    let rating: Double
    let coordinates: Center
    
    enum CodingKeys: String, CodingKey {
        case id, alias, name
        case imageURL = "image_url"
        case url, rating, coordinates
    }
   
}
struct Center: Codable {
    let latitude, longitude: Double
    
}
