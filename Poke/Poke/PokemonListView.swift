//
//  ContentView.swift
//  Poke
//
//  Created by Khushali on 22/05/24.
//

import SwiftUI
import Combine

struct PokemonListView: View {
    @StateObject private var viewModel = PokemonListViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.pokemons) { pokemon in
                NavigationLink(destination: PokemonDetailView(url: pokemon.url)) {
                    Text(pokemon.name.capitalized)
                }
            }
            .navigationTitle("Pokémon")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        viewModel.toggleSort()
                    }) {
                        Text(viewModel.isSortedByID ? "Sort by Name" : "Sort by ID")
                    }
                }
            }
            .onAppear {
                viewModel.fetchPokemons()
            }
        }
    }
}

class PokemonListViewModel: ObservableObject {
    @Published var pokemons: [Pokemon] = []
    @Published var isSortedByID = true
    private var cancellables = Set<AnyCancellable>()
    private let service = PokemonService()
    
    func fetchPokemons() {
        service.fetchPokemons()
            .receive(on: DispatchQueue.main)
                        .sink(receiveCompletion: { completion in
                            if case .failure(let error) = completion {
                                print("Failed to fetch pokemons: \(error)")
                            }
                        }, receiveValue: { [weak self] pokemons in
                            self?.pokemons = pokemons
                            self?.toggleSort()
                        })
                        .store(in: &cancellables)
    }
    
    func toggleSort() {
        isSortedByID.toggle()
        if isSortedByID {
            pokemons.sort { $0.id < $1.id }
        } else {
            pokemons.sort { $0.name < $1.name }
        }
    }
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
       PokemonListView()
    }
}
