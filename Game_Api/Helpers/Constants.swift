//
//  Constants.swift
//  Game_Api
//
//  Created by murat albayrak on 24.04.2024.
//



import Foundation

struct Constants {

    static var id: Int = 3939
    static let apiKey : String = "611c10bfc91f46ec98465ba3b7d208ec"
    static let baseURL: String = "https://api.rawg.io/api/games"
    static let imageBaseURL: String = "https://media.rawg.io/media/games/"
    static let gameListURL: String = baseURL + "?key=" + apiKey + "&page=1" // bu page isini hallet
    static let gameDetailsURL: String = baseURL + "/" + "\(id)" + "?key=" + apiKey

    // sample image urls
    // "https://media.rawg.io/media/games/20a/20aa03a10cda45239fe22d035c0ebe64.jpg"
    // "https://media.rawg.io/media/games/618/618c2031a07bbff6b4f611f10b6bcdbc.jpg"
    
    // sample games url
    // https://api.rawg.io/api/games?key=611c10bfc91f46ec98465ba3b7d208ec&page=2

    // sample game details url
    // https://api.rawg.io/api/games/3939?key=b04b62608f7a4d8e9202add331171180

}


