import Hummingbird
import HummingbirdPostgresDatabase

extension HBApplication {
    func setupDatabase() async throws {
        services.setUpPostgresDatabase(
            configuration: .init(
                host: "localhost",
                port: 5432,
                username: "hummingbird",
                password: "hummingbird_password",
                database: "hb-parks",
                tls: .disable
            ),
            eventLoopGroup: eventLoopGroup,
            logger: logger
        )
                
        try await db.execute(
            .init(unsafeSQL:
                                   """
                                   CREATE TABLE IF NOT EXISTS parks (
                                       "id" uuid PRIMARY KEY,
                                       "latitude" double precision NOT NULL,
                                       "longitude" double precision NOT NULL,
                                       "name" text NOT NULL
                                   );
                                   """
                 )
        )
    }
}
