//
//  NetworkService.swift
//  InfiniteListVK
//
//  Created by Никита Кисляков on 29.11.2024.
//

import Foundation

protocol NetworkServiceProtocol {
    func getPokemons(offset: Int) async throws -> PokemonResponse
    func getPokemonDetail(url: String) async throws -> PokemonDetailResponse
}

struct NetworkService {
    private init() {}
    
    static let shared: NetworkService = NetworkService()
}

extension NetworkService: NetworkServiceProtocol {
    
    func getPokemons(offset: Int) async throws -> PokemonResponse {
        guard let url = URL(string: Endpoints.pokemons(offset: offset).url) else { throw NetworkError.invalidURL }
        
        var request = URLRequest(url: url)
            request.cachePolicy = .reloadIgnoringLocalCacheData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(PokemonResponse.self, from: data)
        } catch {
            throw NetworkError.parsingError
        }
    }
    
    func getPokemonDetail(url: String) async throws -> PokemonDetailResponse {
        guard let url = URL(string: url) else { throw NetworkError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(PokemonDetailResponse.self, from: data)
        } catch {
            throw NetworkError.parsingError
        }
    }
}

