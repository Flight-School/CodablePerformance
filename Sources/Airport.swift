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
    public init(json: [String: Any]) throws {
        guard let name = json["name"] as? String else { throw NSError() }
        guard let iata = json["iata"] as? String else { throw NSError() }
        guard let icao = json["icao"] as? String else { throw NSError() }
        guard let coordinates = json["coordinates"] as? [Double] else { throw NSError() }
        guard let runways = json["runways"] as? [[String: Any]] else { throw NSError() }
      
        self.name = name
        self.iata = iata
        self.icao = icao
        self.coordinates = coordinates
      do {
        self.runways = try runways.map { try Runway(json: $0) }
      } catch (let e) {
        throw e
      }
      
    }
}

extension Airport.Runway {
    public init(json: [String: Any]) throws {
        guard let direction = json["direction"] as? String else { throw NSError() }
        guard let distance = json["distance"] as? Int else { throw NSError() }
        guard let surfaceRawValue = json["surface"] as? String else { throw NSError() }
        guard let surface = Surface(rawValue: surfaceRawValue) else { throw NSError() }
        
        self.direction = direction
        self.distance = distance
        self.surface = surface
    }
}
