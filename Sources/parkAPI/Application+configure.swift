import Hummingbird
import HummingbirdFoundation


public protocol AppArguments {}

public extension HBApplication {
    func configure() async throws {
        // Setup the database
        try await setupDatabase()

        // Set encoder and decoder
        encoder = JSONEncoder()
        decoder = JSONDecoder()

        // Logger
        logger.logLevel = .debug

        // Middleware
        middleware.add(HBLogRequestsMiddleware(.debug))
        middleware.add(HBCORSMiddleware(
            allowOrigin: .originBased,
            allowHeaders: ["Content-Type"],
            allowMethods: [.GET, .OPTIONS, .POST, .DELETE, .PATCH]
        ))

        router.get("/") { _ in
            "The server is running...🚀"
        }

        // Additional routes are defined in the controller
        ParkController().addRoutes(to: router.group("api/v1/parks"))
    }
}
