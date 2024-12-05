//
//  CustomErrors.swift
//  InfiniteListVK
//
//  Created by Никита Кисляков on 29.11.2024.
//

import Foundation

enum NetworkError: LocalizedError, Equatable {
    
    case invalidResponse
    case addressUnreachable(URL)
    case invalidURL
    case parsingError
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse: return "The server responded with invalid data."
        case .addressUnreachable(let url): return "\(url.absoluteString) is unreachable."
        case .invalidURL: return "The provided URL is not in a valid format."
        case .parsingError: return "The data could not be parsed."
        }
    }
}
