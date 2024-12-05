//
//  NetworkServiceTesting.swift
//  InfiniteListVKTests
//
//  Created by Никита Кисляков on 05.12.2024.
//
import XCTest
@testable import InfiniteListVK

class NetworkServiceTests: XCTestCase {
    
    var networkService: NetworkServiceProtocol!
    var mockNetworkService: MockNetworkService!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        networkService = mockNetworkService
    }

    override func tearDown() {
        networkService = nil
        mockNetworkService = nil
        super.tearDown()
    }

    func testGetPokemons_Success() async throws {
        let expectedPokemons = PokemonResponse(count: 1, results: [PokemonEntryResponse(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/")])
        mockNetworkService.mockPokemonsResponse = expectedPokemons

        let response = try await networkService.getPokemons(offset: 0)

        XCTAssertEqual(response.count, expectedPokemons.count)
        XCTAssertEqual(response.results?.first?.name, expectedPokemons.results?.first?.name)
    }

    func testGetPokemons_Error() async throws {
        mockNetworkService.shouldReturnError = true

        do {
            _ = try await networkService.getPokemons(offset: 0)
            XCTFail("Expected error not thrown")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidResponse)
        }
    }

    func testGetPokemonDetail_Success() async throws {
        let expectedDetail = PokemonDetailResponse(id: 25, name: "Pikachu", abilities: [AbilityResponse(ability: AbilityEntry(name: "Static", url: nil))])
        mockNetworkService.mockPokemonDetailResponse = expectedDetail

        let response = try await networkService.getPokemonDetail(url: "https://pokeapi.co/api/v2/pokemon/25/")

        XCTAssertEqual(response.id, expectedDetail.id)
        XCTAssertEqual(response.name, expectedDetail.name)
        XCTAssertEqual(response.abilities?.first?.ability?.name, expectedDetail.abilities?.first?.ability?.name)
    }

    func testGetPokemonDetail_Error() async throws {
        mockNetworkService.shouldReturnError = true

        do {
            _ = try await networkService.getPokemonDetail(url: "https://pokeapi.co/api/v2/pokemon/25/")
            XCTFail("Expected error not thrown")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidResponse)
        }
    }
}
