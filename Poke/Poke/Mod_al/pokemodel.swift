import Foundation

struct Pokemon: Identifiable, Decodable {
    //let id: Int
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case name, url
    }
    
    var id: Int {
        let urlComponents = URLComponents(string: url)
        let idString = urlComponents?.path.split(separator: "/").last ?? ""
        return Int(idString) ?? 0
    }
}

struct PokemonDetail: Decodable {
    let id: Int
    let name: String
    let baseExperience: Int
    let abilities: [Ability]
    let sprites: Sprites
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case baseExperience = "base_experience"
        case abilities, sprites
    }
}


struct Ability: Decodable {
    let ability: NamedAPIResource
}

struct NamedAPIResource: Decodable {
    let name: String
}

struct Sprites: Decodable {
    let frontDefault: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
