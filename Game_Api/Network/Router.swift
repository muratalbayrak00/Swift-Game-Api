//
//  Router.swift
//  Game_Api
//
//  Created by murat albayrak on 25.04.2024.
//

import Alamofire
import Foundation


enum Router: URLRequestConvertible {
    
    case listGames
    case gameDetails
    
    var method: HTTPMethod {
        switch self {
        case .listGames, .gameDetails:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .listGames, .gameDetails:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        JSONEncoding.default
    }
    
    var url: URL {
        
        switch self {
        case .gameDetails:
            let url = URL(string: Constants.gameDetailsURL)
            return url!
        case .listGames:
            let url = URL(string: Constants.gameListURL)
            return url!
        }
        
    }
    
    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return try encoding.encode(urlRequest, with: parameters)
    }
    
}
