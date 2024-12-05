//
//  PokemonsUseCaseTesting.swift
//  InfiniteListVKTests
//
//  Created by Никита Кисляков on 05.12.2024.
//
import XCTest
@testable import InfiniteListVK

final class MainViewModelTests: XCTestCase {
    
    var viewModel: MainViewModel!
    var mockUseCase: MockPokemonsUseCase!
    
    override func setUp() async throws {
        try await super.setUp()
        mockUseCase = MockPokemonsUseCase()
        viewModel = await MainViewModel(pokemonsUseCase: mockUseCase)
    }
    
    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        super.tearDown()
    }
    
    @MainActor
    func testLoadInitialPokemons_Success() async throws {
        let pokemon1 = PokemonEntryModel(name: "Pikachu", url: "url1", isDeleted: false)
        let pokemon2 = PokemonEntryModel(name: "Bulbasaur", url: "url2", isDeleted: true)
        mockUseCase.savedPokemons = [pokemon1, pokemon2]
        
        try await viewModel.loadInitialPokemons()
        
        XCTAssertEqual(viewModel.pokemons.count, 1)
        XCTAssertEqual(viewModel.pokemons.first?.url, "url1")
        XCTAssertEqual(viewModel.deletedPokemons.count, 1)
        XCTAssertEqual(viewModel.deletedPokemons.first?.url, "url2")
    }
    
    @MainActor
    func testLoadInitialPokemons_Error() async throws {
        mockUseCase.shouldReturnError = true
        
        do {
            try await viewModel.loadInitialPokemons()
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertNotNil(viewModel.errorMessage)
        }
    }
    
    @MainActor
    func testDownloadPokemons_Success() async throws {
        let pokemon1 = PokemonEntryModel(name: "Pikachu", url: "url1", isDeleted: false)
        mockUseCase.savedPokemons = [pokemon1]
        try await viewModel.loadInitialPokemons()
        
        let newPokemon = PokemonEntryModel(name: "Charmander", url: "url2", isDeleted: false)
        mockUseCase.newPokemons = [newPokemon]
        
        try await viewModel.downloadPokemons(offset: 0)
        
        XCTAssertEqual(viewModel.pokemons.count, 2)
        XCTAssertEqual(viewModel.pokemons.last?.url, "url2")
    }
    
    @MainActor
    func testDeletePokemon() async throws {
        let pokemon1 = PokemonEntryModel(name: "Pikachu", url: "url1", isDeleted: false)
        mockUseCase.savedPokemons = [pokemon1]
        try await viewModel.loadInitialPokemons()
        
        try await viewModel.deletePokemon(pokemon: pokemon1)
        
        XCTAssertEqual(viewModel.pokemons.count, 0)
        XCTAssertEqual(viewModel.deletedPokemons.count, 1)
    }
    
    @MainActor
    func testDownloadPokemons_Error() async throws {
        let pokemon1 = PokemonEntryModel(name: "Pikachu", url: "url1", isDeleted: false)
        mockUseCase.savedPokemons = [pokemon1]
        try await viewModel.loadInitialPokemons()
        
        mockUseCase.shouldReturnError = true
        
        do {
            try await viewModel.downloadPokemons(offset: 0)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertNotNil(viewModel.errorMessage)
        }
    }
}
