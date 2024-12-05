//
//  DetailViewModelTesting.swift
//  InfiniteListVKTests
//
//  Created by Никита Кисляков on 05.12.2024.
//
import XCTest
@testable import InfiniteListVK

final class DetailViewModelTests: XCTestCase {
    
    var viewModel: DetailViewModel!
    var mockUseCase: MockPokemonsUseCase!
    
    override func setUp() async throws {
        try await super.setUp()
        mockUseCase = MockPokemonsUseCase()
        viewModel = await DetailViewModel(pokemonsUseCase: mockUseCase)
    }
    
    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        super.tearDown()
    }
    
    @MainActor
    func testGetDetails_FromDB_Success() async throws {
        let pokemonEntry = PokemonEntryModel(name: "Pikachu", url: "url1", isDeleted: false)
        let pokemonDetail = PokemonDetailModel(id: 1, name: "Pikachu", abilities: ["Static", "Lightning Rod"])
        mockUseCase.pokemonDetail = pokemonDetail
        
        try await viewModel.getDetails(pokemon: pokemonEntry)
        
        XCTAssertEqual(viewModel.pokemon?.name, "Pikachu")
        XCTAssertEqual(viewModel.editedAbilities, ["Static", "Lightning Rod"])
        XCTAssertNil(viewModel.error)
    }
    
    @MainActor
    func testGetDetails_FromDB_NoDetail() async throws {
        let pokemonEntry = PokemonEntryModel(name: "Pikachu", url: "url1", isDeleted: false)
        mockUseCase.pokemonDetail = nil
        
        let pokemonDetail = PokemonDetailModel(id: 1, name: "Pikachu", abilities: ["Static", "Lightning Rod"])
        mockUseCase.pokemonDetail = pokemonDetail
        
        try await viewModel.getDetails(pokemon: pokemonEntry)
        
        XCTAssertEqual(viewModel.pokemon?.name, "Pikachu")
        XCTAssertEqual(viewModel.editedAbilities, ["Static", "Lightning Rod"])
        XCTAssertNil(viewModel.error)
    }
    
    @MainActor
    func testGetDetails_Error() async throws {
        let pokemonEntry = PokemonEntryModel(name: "Pikachu", url: "url1", isDeleted: false)
        mockUseCase.shouldReturnError = true
        
        try await viewModel.getDetails(pokemon: pokemonEntry)
        
        XCTAssertNil(viewModel.pokemon)
        XCTAssertNotNil(viewModel.error)
    }
}
   

