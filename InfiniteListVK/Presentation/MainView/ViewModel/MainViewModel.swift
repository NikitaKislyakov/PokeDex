//
//  MainViewModel.swift
//  InfiniteListVK
//
//  Created by Никита Кисляков on 29.11.2024.
//

import SwiftUI

@MainActor
final class MainViewModel: ObservableObject {
    
    @Published var pokemons: [PokemonEntryModel] = []
    var deletedPokemons: [PokemonEntryModel] = []
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    let pokemonsUseCase: PokemonsUseCase
    
    private var offset: Int = 0
    
    init(pokemonsUseCase: PokemonsUseCase) {
        self.pokemonsUseCase = pokemonsUseCase
    }
    
    func loadInitialPokemons() async throws {
        do {
            if let savedPokemons = try await getSavedPokemons() {
                self.pokemons = savedPokemons.filter({ !$0.isDeleted })
                self.deletedPokemons = savedPokemons.filter({ $0.isDeleted })
            }
        } catch {
            print(error.localizedDescription)
        }
        self.offset = self.pokemons.count
        
        await loadMorePokemons()
    }
    
    func downloadPokemons(offset: Int) async throws {
        guard !isLoading else { return }
        isLoading = true
        
        let result = try await pokemonsUseCase.execute(offset: offset)
        switch result {
        case .success(let newPokemons):
            
            let uniquePokemons = newPokemons.filter({ newPokemon in
                !deletedPokemons.contains(where: { $0.url == newPokemon.url }) && !self.pokemons.contains(where: { $0.url == newPokemon.url })
            })

            if !uniquePokemons.isEmpty {
                withAnimation {
                    self.pokemons.append(contentsOf: uniquePokemons)
                    self.offset += uniquePokemons.count
                }
            } else {
                self.offset += 20
            }
            
            self.isLoading = false
        case .failure(let failure):
            self.isLoading = false
            self.errorMessage = failure.localizedDescription
        }
    }

    func deletePokemon(pokemon: PokemonEntryModel) async throws {
        if let index = self.pokemons.firstIndex(where: { $0.url == pokemon.url }) {
            self.pokemons.remove(at: index)
        }
        self.deletedPokemons.append(pokemon)
        try await pokemonsUseCase.deletePokemon(pokemon: pokemon)
    }
    
    func getSavedPokemons() async throws -> [PokemonEntryModel]? {
        let result = try await pokemonsUseCase.executeFromRealm()
        
        switch result {
        case .success(let pokemons):
            return pokemons
        case .failure(let failure):
            print(failure.localizedDescription)
            return nil
        }
    }
}

extension MainViewModel {
    func shouldLoadMore(pokemon: PokemonEntryModel) -> Bool {
        let totalCount = pokemons.count
        let threshold = 5
        guard let currentPokemonIndex = pokemons.firstIndex(where: {$0.url == pokemon.url}) else { return false }
        
        if totalCount - currentPokemonIndex <= threshold {
            return true
        }
        return false
    }
    
    func loadMorePokemons() async {
        guard !isLoading else { return }
        
        do {
            try await downloadPokemons(offset: offset)
        } catch {
            print(error)
        }
    }
}


