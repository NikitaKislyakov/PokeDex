//
//  DetailViewModel.swift
//  InfiniteListVK
//
//  Created by Никита Кисляков on 02.12.2024.
//

import SwiftUI

@MainActor
final class DetailViewModel: ObservableObject {
    
    @Published var pokemon: PokemonDetailModel? = nil
    @Published var error: String? = nil
    @Published var editedAbilities: [String] = []
    
    let pokemonsUseCase: PokemonsUseCase
    
    init(pokemonsUseCase: PokemonsUseCase){
        self.pokemonsUseCase = pokemonsUseCase
    }
    
    func getDetails(pokemon: PokemonEntryModel) async throws {
        var pokemonFromDB: PokemonDetailModel? = nil
        do {
            pokemonFromDB = try await pokemonsUseCase.getPokemonDetailsFromDB(pokemon: pokemon)
        } catch {
            print(error)
        }
        
        if let pokemonDB = pokemonFromDB {
            self.pokemon = pokemonDB
        } else {
            let result = try await pokemonsUseCase.executeDetail(url: pokemon.url)

            switch result {
            case.success(let pokemon):
                self.pokemon = pokemon
                self.editedAbilities = pokemon.abilities
            case .failure(let error):
                print(error.localizedDescription)
                self.error = error.localizedDescription
            }
        }
    }
    
    func saveDetails() async {
        guard let pokemon = pokemon else { return }
        
        do {
            var updatedPokemon = pokemon
            updatedPokemon.abilities = editedAbilities
            
            try await pokemonsUseCase.savePokemonDetails(pokemon: updatedPokemon)
        } catch {
            print("Error saving details: \(error)")
        }
    }


}
