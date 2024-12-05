//
//  PokemonDetailResponse.swift
//  InfiniteListVK
//
//  Created by Никита Кисляков on 30.11.2024.
//

import Foundation

struct PokemonDetailResponse: Codable {
    let id: Int?
    let name: String?
    let abilities: [AbilityResponse]?
}

struct AbilityResponse: Codable {
    let ability: AbilityEntry?
}

struct AbilityEntry: Codable {
    let name: String?
    let url: String?
}


