//
//  MockUseCase.swift
//  InfiniteListVKTests
//
//  Created by Никита Кисляков on 05.12.2024.
//

import XCTest
@testable import InfiniteListVK


class MockPokemonsUseCase: PokemonsUseCase {
    var shouldReturnError = false
    var savedPokemons: [PokemonEntryModel] = []
    var newPokemons: [PokemonEntryModel] = []
    var pokemonDetail: PokemonDetailModel?
    
    func execute(offset: Int) async throws -> Result<[PokemonEntryModel], Error> {
        if shouldReturnError {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Test error"]))
        }
        return .success(newPokemons)
    }
    
    func executeFromRealm() async throws -> Result<[PokemonEntryModel], Error> {
        return .success(savedPokemons)
    }
    
    func deletePokemon(pokemon: PokemonEntryModel) async throws {
        if let index = savedPokemons.firstIndex(where: { $0.url == pokemon.url }) {
            savedPokemons.remove(at: index)
        } else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Pokemon not found"])
        }
    }
    
    func executeDetail(url: String) async throws -> Result<PokemonDetailModel, Error> {
        if let detail = pokemonDetail {
            return .success(detail)
        } else if shouldReturnError {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Test error"]))
        }
        return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No detail available"]))
    }
    
    func savePokemonDetails(pokemon: PokemonDetailModel) async throws {
        let newPokemonEntry = PokemonEntryModel(name: pokemon.name, url: "url")
        savedPokemons.append(newPokemonEntry)
        pokemonDetail = pokemon
    }
    
    func getPokemonDetailsFromDB(pokemon: PokemonEntryModel) async throws -> PokemonDetailModel? {
        return pokemonDetail
    }
}
