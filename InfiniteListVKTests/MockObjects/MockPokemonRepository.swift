//
//  MockPokemonRepository.swift
//  InfiniteListVKTests
//
//  Created by Никита Кисляков on 05.12.2024.
//

import XCTest
import RealmSwift
@testable import InfiniteListVK

class MockPokemonRepository: PokemonRepositoryProtocol {
    var shouldReturnError = false
    var savedPokemons: [PokemonEntryModel] = []
    var downloadedPokemons: [PokemonEntryModel] = []
    var pokemonDetail: PokemonDetailModel?
    
    func downloadPokemons(offset: Int) async throws -> [PokemonEntryModel] {
        if shouldReturnError {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        }
        return downloadedPokemons
    }
    
    func getSavedPokemonsFromDB() throws -> [PokemonEntryModel] {
        if shouldReturnError {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        }
        return savedPokemons
    }
    
    func downloadPokemonDetails(url: String)  throws -> PokemonDetailModel {
        if shouldReturnError {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        }
        guard let detail = pokemonDetail else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No detail available"])
        }
        return detail
    }
    
    func savePokemonDetails(pokemon: PokemonDetailModel)  throws {
        if shouldReturnError {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Save error"])
        }
        
    }
    
    func deletePokemon(pokemon: PokemonEntryModel) throws {
        if shouldReturnError {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Delete error"])
        }
        
        if let index = savedPokemons.firstIndex(where: { $0.url == pokemon.url }) {
            savedPokemons.remove(at: index)
        } else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Pokemon not found"])
        }
    }
    
    func getPokemonDetailsFromDB(pokemon: PokemonEntryModel) throws -> PokemonDetailModel? {
        return pokemonDetail
    }
}
