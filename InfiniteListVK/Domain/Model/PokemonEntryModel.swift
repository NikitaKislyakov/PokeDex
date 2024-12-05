//
//  PokemonEntryModel.swift
//  InfiniteListVK
//
//  Created by Никита Кисляков on 29.11.2024.
//

import Foundation

struct PokemonEntryModel: Hashable, Identifiable {
    var id: UUID = .init()
    let name: String
    let url: String
    var isDeleted: Bool = false
    
    var imageUrl: String {
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(url.split(separator: "/").last ?? "1").png"
    }
}


