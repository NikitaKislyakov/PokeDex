//
//  APICall.swift
//  InfiniteListVK
//
//  Created by Никита Кисляков on 29.11.2024.
//

import Foundation

struct API {
    static let baseUrl = "https://pokeapi.co/api/v2/"
}

protocol Endpoint {
    var url: String { get }
}

enum Endpoints: Endpoint {
    case pokemons(offset: Int)
    
    var url: String {
        switch self {
            case .pokemons(let offset): return "\(API.baseUrl)pokemon?offset=\(offset)&limit=20"
        }
    }
}


