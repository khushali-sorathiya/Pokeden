//
//  PokeTests.swift
//  PokeTests
//
//  Created by Khushali on 22/05/24.
//

import XCTest
import Combine

@testable import Poke

final class PokeTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

   
        
        override func setUp() {
            super.setUp()
            cancellables = []
        }
        
        override func tearDown() {
            cancellables = nil
            super.tearDown()
        }
        
        func testFetchPokemons() {
            let service = PokemonService()
            let expectation = XCTestExpectation(description: "Fetch Pokemons")
            
            service.fetchPokemons()
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTFail("Error: \(error.localizedDescription)")
                    }
                }, receiveValue: { pokemons in
                    XCTAssertFalse(pokemons.isEmpty, "Pokemons list should not be empty")
                    expectation.fulfill()
                })
                .store(in: &cancellables)
            
            wait(for: [expectation], timeout: 10.0)
        }
        
        func testFetchPokemonDetail() {
            let service = PokemonService()
            let expectation = XCTestExpectation(description: "Fetch Pokemon Detail")
            let url = "https://pokeapi.co/api/v2/pokemon/1/"
            
            service.fetchPokemonDetail(url: url)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTFail("Error: \(error.localizedDescription)")
                    }
                }, receiveValue: { detail in
                    XCTAssertEqual(detail.id, 1, "Pokemon ID should be 1")
                    expectation.fulfill()
                })
                .store(in: &cancellables)
            
            wait(for: [expectation], timeout: 10.0)
        }
    }
