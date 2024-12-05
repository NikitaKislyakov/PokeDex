//
//  PokemonDetailEntity.swift
//  InfiniteListVK
//
//  Created by Никита Кисляков on 05.12.2024.
//

import Foundation
import RealmSwift

class AbilityEntity: Object {
    @objc dynamic var name: String = ""
}

class PokemonDetailEntity: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    let abilities = List<AbilityEntity>()
    
    override class func primaryKey() -> String? {
        return "name"
    }
}
