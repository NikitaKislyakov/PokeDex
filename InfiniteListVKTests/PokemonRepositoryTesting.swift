//
//  PokemonsUseCaseTesting.swift
//  InfiniteListVKTests
//
//  Created by Никита Кисляков on 05.12.2024.
//

import XCTest
import RealmSwift
@testable import InfiniteListVK

class PokemonRepositoryTests: XCTestCase {
    
    var repository: PokemonRepository!
    var mockNetworkService: MockNetworkService!
    var realm: Realm!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        repository = PokemonRepository(service: mockNetworkService)
        
        let config = Realm.Configuration(inMemoryIdentifier: "TestRealm")
        realm = try! Realm(configuration: config)
    }

    override func tearDown() {
        repository = nil
        mockNetworkService = nil
        try! realm.write {
            realm.deleteAll()
        }
        super.tearDown()
    }

    func testDownloadPokemons() async throws {
        let expectedPokemons = [PokemonEntryModel(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/")]
        mockNetworkService.mockPokemonsResponse = PokemonResponse(count: 1, results: expectedPokemons.map { PokemonEntryResponse(name: $0.name, url: $0.url) })

        let pokemons = try await repository.downloadPokemons(offset: 0)

        XCTAssertEqual(pokemons.count, expectedPokemons.count)
        XCTAssertEqual(pokemons[0].name, expectedPokemons[0].name)
        XCTAssertEqual(pokemons[0].url, expectedPokemons[0].url)
    }

    func testDownloadPokemonDetails() async throws {
        let expectedDetail = PokemonDetailModel(id: 25, name: "Pikachu", abilities: ["Static", "Lightning Rod"])
        
        let ability1 = AbilityResponse(ability: AbilityEntry(name: "Static", url: nil))
        let ability2 = AbilityResponse(ability: AbilityEntry(name: "Lightning Rod", url: nil))
        mockNetworkService.mockPokemonDetailResponse = PokemonDetailResponse(id: expectedDetail.id, name: expectedDetail.name, abilities: [ability1, ability2])

        let detail = try await repository.downloadPokemonDetails(url: "https://pokeapi.co/api/v2/pokemon/25/")

        XCTAssertEqual(detail.id, expectedDetail.id)
        XCTAssertEqual(detail.name, expectedDetail.name)
        XCTAssertEqual(detail.abilities, expectedDetail.abilities)
    }

    func testGetSavedPokemonsFromDB() throws {
        let pokemon = PokemonEntity()
        pokemon.name = "Pikachu"
        pokemon.url = "https://pokeapi.co/api/v2/pokemon/25/"
        try realm.write {
            realm.add(pokemon)
        }

        let savedPokemons = try repository.getSavedPokemonsFromDB()

        XCTAssertEqual(savedPokemons.count, 1)
        XCTAssertEqual(savedPokemons[0].name, "Pikachu")
    }

    func testDeletePokemon() throws {
        let pokemon = PokemonEntity()
        pokemon.url = "https://pokeapi.co/api/v2/pokemon/25/"
        pokemon.isDeleted = false
        try realm.write {
            realm.add(pokemon)
        }
        
        let pokemonModel = PokemonEntryModel(name: "Pikachu", url: pokemon.url)

        try repository.deletePokemon(pokemon: pokemonModel)

        let deletedPokemon = realm.object(ofType: PokemonEntity.self, forPrimaryKey: pokemon.url)
        XCTAssertTrue(deletedPokemon?.isDeleted ?? false)
    }

    func testSavePokemonDetails() throws {
        let pokemonDetail = PokemonDetailModel(id: 25, name: "Pikachu", abilities: ["Static", "Lightning Rod"])

        try repository.savePokemonDetails(pokemon: pokemonDetail)

        let savedDetail = realm.object(ofType: PokemonDetailEntity.self, forPrimaryKey: pokemonDetail.name)
        XCTAssertNotNil(savedDetail)
        XCTAssertEqual(savedDetail?.name, pokemonDetail.name)
        XCTAssertEqual(savedDetail?.abilities.count, pokemonDetail.abilities.count)
        XCTAssertEqual(savedDetail?.abilities.map { $0.name }, pokemonDetail.abilities)
    }

    func testGetPokemonDetailsFromDB() throws {
        let pokemonDetail = PokemonDetailEntity()
        pokemonDetail.id = 25
        pokemonDetail.name = "Pikachu"
        let ability = AbilityEntity()
        ability.name = "Static"
        pokemonDetail.abilities.append(ability)
        try realm.write {
            realm.add(pokemonDetail)
        }

        let pokemonModel = PokemonEntryModel(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/")
        let detailFromDB = try repository.getPokemonDetailsFromDB(pokemon: pokemonModel)

        XCTAssertNotNil(detailFromDB)
        XCTAssertEqual(detailFromDB?.id, pokemonDetail.id)
        XCTAssertEqual(detailFromDB?.name, pokemonDetail.name)
        XCTAssertEqual(detailFromDB?.abilities, ["Static"])
    }

    func testGetPokemonDetailsFromDB_NonExistentPokemon() throws {
        let pokemonModel = PokemonEntryModel(name: "NonExistentPokemon", url: "https://pokeapi.co/api/v2/pokemon/999/")

        let detailFromDB = try repository.getPokemonDetailsFromDB(pokemon: pokemonModel)

        XCTAssertNil(detailFromDB)
    }

    func testDownloadPokemons_ErrorHandling() async throws {
        mockNetworkService.shouldReturnError = true
        
        do {
            _ = try await repository.downloadPokemons(offset: 0)
            XCTFail("Expected error not thrown")
        } catch {
            XCTAssertEqual(error as? URLError, URLError(.badServerResponse))
        }
    }
}



