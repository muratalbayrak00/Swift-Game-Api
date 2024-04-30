//
//  GameLogic.swift
//  Game_Api
//
//  Created by murat albayrak on 25.04.2024.
//

import Foundation

final class GameLogic: GameLogicProtocol {
    
    static let shared: GameLogic = {
        let instance = GameLogic()
        return instance
    }()
    
    func getListGames(completionHandler: @escaping (Result<ListGames, Error>) -> Void) {
        
        Webservice.shared.request(request: Router.listGames, decodeToType: ListGames.self, completionHandler: completionHandler)
    }
    
    func getGameDetails(gameID: Int, completionHandler: @escaping (Result<GameDetails, Error>) -> Void) {
        
        let gameDetailsRequest = Router.gameDetails
        let gameDetailsURL = Constants.baseURL + "/\(gameID)" + "?key=" + Constants.apiKey
        var urlRequest = URLRequest(url: URL(string: gameDetailsURL)!)
        urlRequest.httpMethod = gameDetailsRequest.method.rawValue
        
        do {
            urlRequest = try gameDetailsRequest.encoding.encode(urlRequest, with: gameDetailsRequest.parameters)
        } catch {
            completionHandler(.failure(error))
            return
        }
        
        Webservice.shared.request(request: urlRequest, decodeToType: GameDetails.self, completionHandler: completionHandler)
    }
    
}

protocol GameLogicProtocol {
    
    func getListGames(completionHandler: @escaping (Result<ListGames, Error>) -> Void)
    func getGameDetails(gameID: Int, completionHandler: @escaping (Result<GameDetails, Error>) -> Void)
}
