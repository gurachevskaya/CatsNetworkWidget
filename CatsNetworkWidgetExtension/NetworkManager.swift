//
//  NetworkManager.swift
//  CatsNetworkWidget
//
//  Created by Karina gurachevskaya on 22.11.22.
//

import Foundation
import Combine

enum NetworkError: Error {
    case offline
    case network(code: Int, description: String)
    case invalidRequest(description: String)
    case wrongURL
    case unknown
}

protocol NetworkManagerProtocol {
    func fetch(endpoint: Endpoint) -> AnyPublisher<Data, NetworkError>
}

struct NetworkManager: NetworkManagerProtocol {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetch(endpoint: Endpoint) -> AnyPublisher<Data, NetworkError> {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.baseURL
        components.path = endpoint.path
        components.queryItems = endpoint.parameters
        
        guard let url = components.url else {
            return Fail(error: NetworkError.wrongURL)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: URLRequest(url: url))
            .mapError { error in
                if error.code.rawValue == -1009 {
                    return .offline
                }
                return .network(code: error.code.rawValue, description: error.localizedDescription)
            }
            .map(\.data)
            .eraseToAnyPublisher()
    }
}
