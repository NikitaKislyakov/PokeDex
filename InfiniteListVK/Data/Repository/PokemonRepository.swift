//
//  PokemonRepository.swift
//  InfiniteListVK
//
//  Created by Никита Кисляков on 29.11.2024.
//

import Foundation
import RealmSwift

protocol PokemonRepositoryProtocol {
    func downloadPokemons(offset: Int) async throws -> [PokemonEntryModel]
    func downloadPokemonDetails(url: String) async throws -> PokemonDetailModel
    func getSavedPokemonsFromDB() throws -> [PokemonEntryModel]
    func deletePokemon(pokemon: PokemonEntryModel) throws
    func savePokemonDetails(pokemon: PokemonDetailModel) throws
    func getPokemonDetailsFromDB(pokemon: PokemonEntryModel) throws -> PokemonDetailModel?
}

struct PokemonRepository {
    typealias PokemonInstance = (NetworkServiceProtocol) -> PokemonRepository
    
    private let service: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol) {
        self.service = service
    }
    
    static let sharedInstance: PokemonInstance = {  networkService in
        return PokemonRepository(service: networkService)
    }
}

extension PokemonRepository: PokemonRepositoryProtocol {
    
    func downloadPokemons(offset: Int) async throws -> [PokemonEntryModel] {
        do {
            let data = try await service.getPokemons(offset: offset)
            let pokemons = mapPokemonsResponseToDomain(input: data.results ?? [])
            try savePokemonsToRealm(pokemons: pokemons)
            return pokemons
        } catch {
            throw error
        }
    }
    
    func downloadPokemonDetails(url: String) async throws -> PokemonDetailModel {
        do {
            let data = try await service.getPokemonDetail(url: url)
            
            return mapPokemonDetailResponseToDomain(input: data)
        } catch {
            throw error
        }
    }

    func getSavedPokemonsFromDB() throws -> [PokemonEntryModel] {
        let realm = try Realm()
        let savedPokemons = realm.objects(PokemonEntity.self)
        
        return savedPokemons.map { entity in
            var model = PokemonEntryModel(id: entity.id, name: entity.name, url: entity.url)
            if entity.isDeleted {
                model.isDeleted = true
            }
            return model
        }
    }
    
    func getPokemonDetailsFromDB(pokemon: PokemonEntryModel) throws -> PokemonDetailModel? {
        let realm = try Realm()
        if let realmPokemon = realm.object(ofType: PokemonDetailEntity.self, forPrimaryKey: pokemon.name) {
            return PokemonDetailModel(id: realmPokemon.id, name: realmPokemon.name, abilities: realmPokemon.abilities.map({ ability in
                ability.name
            }))
        }
        return nil
    }

    func deletePokemon(pokemon: PokemonEntryModel) throws {
        let realm = try Realm()
        if let realmPokemon = realm.object(ofType: PokemonEntity.self, forPrimaryKey: pokemon.url) {
            try realm.write {
                realmPokemon.isDeleted = true
            }
        }
    }
    
    func savePokemonDetails(pokemon: PokemonDetailModel) throws {
        let realm = try Realm()
        
        if let realmPokemon = realm.object(ofType: PokemonDetailEntity.self, forPrimaryKey: pokemon.name) {
            try realm.write {
                realmPokemon.abilities.removeAll()
                
                for ability in pokemon.abilities {
                    let abilityEntity = AbilityEntity()
                    abilityEntity.name = ability
                    realmPokemon.abilities.append(abilityEntity)
                }
            }
        } else {
            let realmPokemon = PokemonDetailEntity()
            realmPokemon.name = pokemon.name
            
            for ability in pokemon.abilities {
                let abilityEntity = AbilityEntity()
                abilityEntity.name = ability
                realmPokemon.abilities.append(abilityEntity)
            }
            
            try realm.write {
                realm.add(realmPokemon, update: .modified)
            }
        }
    }

    private func savePokemonsToRealm(pokemons: [PokemonEntryModel]) throws {
        let realm = try Realm()
        try realm.write {
            for pokemon in pokemons {
                if let existingPokemon = realm.object(ofType: PokemonEntity.self, forPrimaryKey: pokemon.url) {
                    if existingPokemon.isDeleted {
                        continue
                    }
                }
                
                let realmPokemon = PokemonEntity()
                realmPokemon.id = pokemon.id
                realmPokemon.name = pokemon.name
                realmPokemon.url = pokemon.url
                realmPokemon.isDeleted = false
                realm.add(realmPokemon, update: .modified)
            }
        }
    }

    private func mapPokemonsResponseToDomain(input response: [PokemonEntryResponse]) -> [PokemonEntryModel] {
        return response.map { result in
            return PokemonEntryModel(
                name: result.name ?? "Unknown",
                url: result.url ?? "Unknown"
            )
        }
    }
    
    private func mapPokemonDetailResponseToDomain(input response: PokemonDetailResponse) -> PokemonDetailModel {
        return PokemonDetailModel(
            id: response.id ?? 0,
            name: response.name ?? "Unknown",
            abilities: response.abilities?.map({ $0.ability?.name ?? "" }) ?? []
        )
    }
}
