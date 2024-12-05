//
//  PokemonsUseCaseTesting.swift
//  InfiniteListVKTests
//
//  Created by Никита Кисляков on 05.12.2024.
//
import XCTest
@testable import InfiniteListVK

final class PokemonsUseTests: XCTestCase {
    
    var useCase: PokemonsUse!
    var mockRepository: MockPokemonRepository!
    
    override func setUp() async throws {
        try await super.setUp()
        mockRepository = MockPokemonRepository()
        useCase = PokemonsUse(repo: mockRepository)
    }
    
    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }
    
    @MainActor
    func testExecute_Success() async throws {
        let pokemon1 = PokemonEntryModel(name: "Pikachu", url: "url1", isDeleted: false)
        let pokemon2 = PokemonEntryModel(name: "Bulbasaur", url: "url2", isDeleted: false)
        mockRepository.downloadedPokemons = [pokemon1, pokemon2]
        
        let result = try await useCase.execute(offset: 0)
        
        switch result {
        case .success(let pokemons):
            XCTAssertEqual(pokemons.count, 2)
            XCTAssertEqual(pokemons.first?.name, "Pikachu")
        case .failure:
            XCTFail("Expected success but got failure")
        }
    }
    
    @MainActor
    func testExecute_Error() async throws {
        mockRepository.shouldReturnError = true
        
        do {
            _ = try await useCase.execute(offset: 0)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    @MainActor
    func testExecuteFromRealm_Success() async throws {
        let pokemon1 = PokemonEntryModel(name: "Pikachu", url: "url1", isDeleted: false)
        mockRepository.savedPokemons = [pokemon1]
        
        let result = try await useCase.executeFromRealm()
        
        switch result {
        case .success(let pokemons):
            XCTAssertEqual(pokemons.count, 1)
            XCTAssertEqual(pokemons.first?.name, "Pikachu")
        case .failure:
            XCTFail("Expected success but got failure")
        }
    }
    
    @MainActor
    func testExecuteFromRealm_Error() async throws {
        mockRepository.shouldReturnError = true
        
        do {
            _ = try await useCase.executeFromRealm()
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    @MainActor
    func testExecuteDetail_Success() async throws {
        let pokemonDetail = PokemonDetailModel(id: 1, name: "Pikachu", abilities: ["Static", "Lightning Rod"])
        mockRepository.pokemonDetail = pokemonDetail
        
        let result = try await useCase.executeDetail(url: "url1")
        
        switch result {
        case .success(let detail):
            XCTAssertEqual(detail.name, "Pikachu")
            XCTAssertEqual(detail.id, 1)
            XCTAssertEqual(detail.abilities, ["Static", "Lightning Rod"])
        case .failure:
            XCTFail("Expected success but got failure")
        }
    }
    
    @MainActor
    func testExecuteDetail_Error() async throws {
        mockRepository.shouldReturnError = true
        
        do {
            _ = try await useCase.executeDetail(url: "url1")
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    @MainActor
    func testSavePokemonDetails_Error() async throws {
        mockRepository.shouldReturnError = true
        let pokemonDetail = PokemonDetailModel(id: 1, name: "Pikachu", abilities: ["Static", "Lightning Rod"])
        
        do {
            try await useCase.savePokemonDetails(pokemon: pokemonDetail)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    @MainActor
    func testGetPokemonDetailsFromDB_Success() async throws {
        let pokemonEntry = PokemonEntryModel(name: "Pikachu", url: "url1", isDeleted: false)
        let pokemonDetail = PokemonDetailModel(id: 1, name: "Pikachu", abilities: ["Static", "Lightning Rod"])
        mockRepository.pokemonDetail = pokemonDetail
        
        let detail = try await useCase.getPokemonDetailsFromDB(pokemon: pokemonEntry)
        
        XCTAssertEqual(detail?.name, "Pikachu")
        XCTAssertEqual(detail?.abilities, ["Static", "Lightning Rod"])
    }
    
    @MainActor
    func testGetPokemonDetailsFromDB_NoDetail() async throws {
        let pokemonEntry = PokemonEntryModel(name: "Pikachu", url: "url1", isDeleted: false)
        mockRepository.pokemonDetail = nil
        
        let detail = try await useCase.getPokemonDetailsFromDB(pokemon: pokemonEntry)
        
        XCTAssertNil(detail)
    }
}

