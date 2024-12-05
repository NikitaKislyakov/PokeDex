//
//  GetPokemons.swift
//  InfiniteListVK
//
//  Created by Никита Кисляков on 29.11.2024.
//

import Foundation

protocol PokemonsUseCase {
    func execute(offset: Int) async throws -> Result<[PokemonEntryModel], Error>
    func executeDetail(url: String) async throws -> Result<PokemonDetailModel, Error>
    func executeFromRealm() async throws -> Result<[PokemonEntryModel], Error>
    func deletePokemon(pokemon: PokemonEntryModel) async throws
    func savePokemonDetails(pokemon: PokemonDetailModel) async throws
    func getPokemonDetailsFromDB(pokemon: PokemonEntryModel) async throws -> PokemonDetailModel?
}

struct PokemonsUse: PokemonsUseCase {
    let repo: PokemonRepositoryProtocol
    
    func execute(offset: Int) async throws -> Result<[PokemonEntryModel], Error> {
        do {
            let pokemons = try await repo.downloadPokemons(offset: offset)
            return .success(pokemons)
        } catch {
            return .failure(error)
        }
    }
    
    func deletePokemon(pokemon: PokemonEntryModel) async throws {
        try repo.deletePokemon(pokemon: pokemon)
    }
    
    func executeFromRealm() async throws -> Result<[PokemonEntryModel], Error> {
        do {
            let pokemons = try repo.getSavedPokemonsFromDB()
            return .success(pokemons)
        } catch {
            return .failure(error)
        }
    }
    
    func executeDetail(url: String) async throws -> Result<PokemonDetailModel, Error> {
        do {
            let pokemon = try await repo.downloadPokemonDetails(url: url)
            return .success(pokemon)
        } catch {
            return .failure(error)
        }
    }
    
    func savePokemonDetails(pokemon: PokemonDetailModel) async throws {
        try repo.savePokemonDetails(pokemon: pokemon)
    }
    
    func getPokemonDetailsFromDB(pokemon: PokemonEntryModel) async throws -> PokemonDetailModel? {
        try repo.getPokemonDetailsFromDB(pokemon: pokemon)
    }
}
