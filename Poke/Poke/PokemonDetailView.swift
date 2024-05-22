//
//  PokemonDetailView.swift
//  Poke
//
//  Created by Khushali on 22/05/24.
//

import SwiftUI
import Combine

struct PokemonDetailView: View {
    @StateObject private var viewModel: PokemonDetailViewModel
    
    init(url: String) {
        _viewModel = StateObject(wrappedValue: PokemonDetailViewModel(url: url))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let pokemon = viewModel.pokemon {
                Text("Name: \(pokemon.name.capitalized)")
                Text("ID: \(pokemon.id)")
                Text("Base Experience: \(pokemon.baseExperience)")
                
                Text("Abilities: \(pokemon.abilities.map { $0.ability.name.capitalized }.joined(separator: ", "))")

                
                if let imageUrl = pokemon.sprites.frontDefault, let url = URL(string: imageUrl) {
                    AsyncImage(url: url)
                }
            } else {
                Text("Loading...")
            }
        }
        .padding()
        .onAppear {
            viewModel.fetchPokemonDetail()
        }
    }
}

class PokemonDetailViewModel: ObservableObject {
    @Published var pokemon: PokemonDetail?
    private let url: String
    private var cancellables = Set<AnyCancellable>()
    private let service = PokemonService()
    
    init(url: String) {
        self.url = url
    }
    
    func fetchPokemonDetail() {
        service.fetchPokemonDetail(url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] pokemon in
                self?.pokemon = pokemon
            })
            .store(in: &cancellables)
    }
}

struct PokemonDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailView(url: "https://pokeapi.co/api/v2/pokemon/1/")
    }
}
