import Foundation
import Combine

class PokemonService {
    private let baseUrl = "https://pokeapi.co/api/v2/pokemon"
    
    func fetchPokemons(limit: Int = 100) -> AnyPublisher<[Pokemon], Error> {
        guard let url = URL(string: "\(baseUrl)?limit=\(limit)") else {
            fatalError("Invalid URL")
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PokemonResponse.self, decoder: JSONDecoder())
            .map { $0.results }
            .eraseToAnyPublisher()
    }
    
    func fetchPokemonDetail(url: String) -> AnyPublisher<PokemonDetail, Error> {
        guard let url = URL(string: url) else {
            fatalError("Invalid URL")
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PokemonDetail.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

struct PokemonResponse: Decodable {
    let results: [Pokemon]
}
