//
//  PokemonResponse.swift
//  InfiniteListVK
//
//  Created by Никита Кисляков on 29.11.2024.
//

import Foundation

struct PokemonResponse: Codable {
    let count: Int?
    let results: [PokemonEntryResponse]?
}

struct PokemonEntryResponse: Codable {
    let name: String?
    let url: String?
}
