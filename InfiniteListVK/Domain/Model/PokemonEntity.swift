//
//  PokemonEntity.swift
//  InfiniteListVK
//
//  Created by Никита Кисляков on 05.12.2024.
//

import Foundation
import RealmSwift

class PokemonEntity: Object {
    @objc dynamic var id: UUID = UUID.init()
    @objc dynamic var name: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var isDeleted: Bool = false
    
    override class func primaryKey() -> String? {
        return "url"
    }
}
