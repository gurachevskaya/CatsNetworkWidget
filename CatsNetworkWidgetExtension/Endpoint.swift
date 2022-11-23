//
//  Endpoint.swift
//  CatsNetworkWidget
//
//  Created by Karina gurachevskaya on 22.11.22.
//

import Foundation

protocol Endpoint {
    // HTTP or HTTPS
    var scheme: String { get }
    
    // "api.flickr.com"
    var baseURL: String { get }
    
    // "/services/rest/"
    var path: String { get }
    
    // [URLQueryItem(name: "api_key", value: API_KEY]
    var parameters: [URLQueryItem] { get }
    
    // "GET"
    var method: String { get }
}
