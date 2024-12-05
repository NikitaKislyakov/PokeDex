//
//  MockNetworkService.swift
//  InfiniteListVKTests
//
//  Created by Никита Кисляков on 05.12.2024.
//

import XCTest
@testable import InfiniteListVK

class MockNetworkService: NetworkServiceProtocol {
    var mockPokemonsResponse: PokemonResponse?
    var mockPokemonDetailResponse: PokemonDetailResponse?
    var shouldReturnError: Bool = false

    func getPokemons(offset: Int) async throws -> PokemonResponse {
        if shouldReturnError {
            throw URLError(.badServerResponse)
        }
        guard let response = mockPokemonsResponse else {
            throw URLError(.badServerResponse)
        }
        return response
    }

    func getPokemonDetail(url: String) async throws -> PokemonDetailResponse {
        if shouldReturnError {
            throw URLError(.badServerResponse)
        }
        guard let response = mockPokemonDetailResponse else {
            throw URLError(.badServerResponse)
        }
        return response
    }
}
