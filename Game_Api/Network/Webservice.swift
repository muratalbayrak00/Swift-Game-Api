//
//  Webservice.swift
//  Game_Api
//
//  Created by murat albayrak on 24.04.2024.
//

import Alamofire
import Foundation


final class Webservice {
    
    static let shared: Webservice = {
        let instance = Webservice()
        return instance
    }()
    
    func request<T: Decodable>(request: URLRequestConvertible, decodeToType type: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) {
            
        AF.request(request).responseData { [weak self] response in
            guard let self else { return }
                
            switch response.result {
                    
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(.success(decodedData))
                    
                } catch {
                    print("Json decode error")
                   
                }
            case .failure(let error):
                completionHandler(.failure(error.localizedDescription as! Error))
            }
        }
    }
}
