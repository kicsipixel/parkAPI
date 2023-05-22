import Foundation
import Hummingbird
import HummingbirdDatabase

extension UUID: LosslessStringConvertible {
    public init?(_ description: String) {
        self.init(uuidString: description)
    }
}

struct ParkController {
    // Define the table in the databse
    let tableName = "parks"
    
    // The routes for CRUD operations
    func addRoutes(to group: HBRouterGroup) {
        group
            .get(use: list)
            .get(":id", use: show)
            .post(options: .editResponse, use: create)
            .patch(":id", use: update)
            .delete(":id", use: deletePark)
    }
    
    // Return all parks
    //
    func list(req: HBRequest) async throws -> [Park] {
        let sql = """
            SELECT * FROM parks
        """
        let query = HBDatabaseQuery(unsafeSQL: sql)
        
        return try await req.db.execute(query, rowType: Park.self)
    }
    
    // Get park with id specified
    func show(req: HBRequest) async throws -> Park? {
        let id = try req.parameters.require("id", as: UUID.self)
        let sql = """
                SELECT * FROM parks WHERE id = :id:
        """
        let query = HBDatabaseQuery(
            unsafeSQL: sql,
            bindings: ["id": id]
        )
        let rows = try await req.db.execute(query, rowType: Park.self)
        
        return rows.first
    }
    
    // Create a new park
    func create(req: HBRequest) async throws -> Park {
        struct CreatePark: Decodable {
            let latitude: Double
            let longitude: Double
            let name: String
        }
        
        let park = try req.decode(as: CreatePark.self)
        let id = UUID()
        let row = Park(
            id: id,
            latitude: park.latitude,
            longitude: park.longitude,
            name: park.name
        )
        let sql = """
                INSERT INTO
                    parks (id, latitude, longitude, name)
                VALUES
                    (:id:, :latitude:, :longitude:, :name:)
                """
        
        try await req.db.execute(.init(unsafeSQL: sql, bindings: row))
        req.response.status = .created
        
        return row
    }
    
    // Update park with id specified
    func update(req: HBRequest) async throws -> HTTPResponseStatus {
        struct UpdatePark: Decodable {
            var latitude: Double
            var longitude: Double
            var name: String
        }
        let id = try req.parameters.require("id", as: UUID.self)
        let park = try req.decode(as: UpdatePark.self)
        let sql = """
                    UPDATE
                        parks
                      SET
                          "latitude" = CASE WHEN :1: IS NOT NULL THEN :1: ELSE "latitude" END,
                          "longitude" = CASE WHEN :2: IS NOT NULL THEN :2: ELSE "longitude" END,
                          "name" = CASE WHEN :3: IS NOT NULL THEN :3: ELSE "name" END
                      WHERE
                          id = :0:
                    """
        try await req.db.execute(
            .init(
                unsafeSQL:
                    sql,
                bindings:
                    id, park.latitude, park.longitude, park.name
            )
        )
        return .ok
    }
    
    // Delete park with id specified
    func deletePark(req: HBRequest) async throws -> HTTPResponseStatus {
        let id = try req.parameters.require("id", as: UUID.self)
        let sql = """
                    DELETE FROM parks WHERE id = :0:
                """
        try await req.db.execute(
            .init(
                unsafeSQL: sql,
                bindings: id
            )
        )
        return .ok
    }
}
