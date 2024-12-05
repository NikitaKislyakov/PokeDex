//
//  Injection.swift
//  InfiniteListVK
//
//  Created by Никита Кисляков on 29.11.2024.
//

import Foundation

struct Injection {
    
    private init() {}
    
    static let shared: Injection = Injection()
    
    private func provideRepository() -> PokemonRepositoryProtocol {
        let service: NetworkService = NetworkService.shared
        return PokemonRepository.sharedInstance(service)
    }
    
    func provideGetPokemonsUseCase() -> PokemonsUseCase {
        PokemonsUse(repo: provideRepository())
    }
}
