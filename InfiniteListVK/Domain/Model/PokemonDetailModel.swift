//
//  PokemonDetailModel.swift
//  InfiniteListVK
//
//  Created by Никита Кисляков on 30.11.2024.
//

import Foundation

struct PokemonDetailModel: Identifiable {
    let id: Int
    let name: String
    var abilities: [String]
    
    var imageUrl: String {
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
    }
}




