import Foundation

public struct Airport: Codable {
    let name: String
    let iata: String
    let icao: String
    let coordinates: [Double]
    
    public struct Runway: Codable {
        enum Surface: String, Codable {
            case rigid, flexible, gravel, sealed, unpaved, other
        }
        
        let direction: String
        let distance: Int
        let surface: Surface
    }
    
    let runways: [Runway]
}

extension Airport {
    public init(json: [String: Any]) {
        guard let name = json["name"] as? String,
            let iata = json["iata"] as? String,
            let icao = json["icao"] as? String,
            let coordinates = json["coordinates"] as? [Double],
            let runways = json["runways"] as? [[String: Any]]
        else {
            fatalError("Cannot initialize Airport from JSON")
        }
        
        self.name = name
        self.iata = iata
        self.icao = icao
        self.coordinates = coordinates
        self.runways = runways.map { Runway(json: $0) }
    }
}

extension Airport.Runway {
    public init(json: [String: Any]) {
        guard let direction = json["direction"] as? String,
            let distance = json["distance"] as? Int,
            let surfaceRawValue = json["surface"] as? String,
            let surface = Surface(rawValue: surfaceRawValue)
            else {
                fatalError("Cannot initialize Runway from JSON")
        }
        
        self.direction = direction
        self.distance = distance
        self.surface = surface
    }
}
