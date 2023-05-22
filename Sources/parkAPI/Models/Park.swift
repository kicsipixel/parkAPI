import Foundation
import Hummingbird

struct Park: Codable {
    let id: UUID
    let latitude: Double
    let longitude: Double
    let name: String

    init(id: UUID, latitude: Double, longitude: Double, name: String) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
    }
}

extension Park: HBResponseCodable {}
