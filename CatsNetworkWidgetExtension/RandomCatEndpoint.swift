//
//  RandomCatEndpoint.swift
//  CatsNetworkWidget
//
//  Created by Karina gurachevskaya on 22.11.22.
//

import Foundation

//https://api.thecatapi.com/v1/images/search
enum CatAPIEndpoint: Endpoint {
    case getRandomCatImage
    
    var scheme: String {
        switch self {
        default:
            return "https"
        }
    }
    
    var baseURL: String {
        return "api.thecatapi.com"
    }
    
    var path: String {
        switch self {
        case .getRandomCatImage:
            return "/v1/images/search"
        }
    }
    
    var parameters: [URLQueryItem] {
        let apiKey = "live_kFdTri3Af4RHnnVgcCafwwxwryZPpf2xBjaXfLCr5Zd9hu9nJzi97Ezi77l0pLYf"
        switch self {
        case .getRandomCatImage:
            return [
                    URLQueryItem(name: "api_key", value: apiKey),
                    URLQueryItem(name: "limit", value: "1")
            ]
        }
    }
    
    var method: String {
        switch self {
        case .getRandomCatImage:
            return "GET"
        }
    }
}
