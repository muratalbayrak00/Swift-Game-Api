//
//  GameDetails.swift
//  Game_Api
//
//  Created by murat albayrak on 25.04.2024.
//

import Foundation

struct GameDetails: Decodable {
    
    let results: [GameDetailsResult]?
    let description: String?
    //   let page: Int // totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case results//, page
        case description
        // case totalResults = "total_results"
        // case totalPages = "total_pages"
    }
}

struct GameDetailsResult: Decodable {
    
    let id: Int?
    let name: String?
    let released: String?
    let rating: Double?
    let imageUrl: String?
    let metacritic: Int?
    let description: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id, name, released, rating, metacritic, description
        case imageUrl = "background_image"
    }
}
