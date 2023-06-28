import Hummingbird
import HummingbirdSQLiteDatabase

extension HBApplication {
    func setupDatabase() async throws {
        services.setUpSQLiteDatabase(
            storage: .file(path: "./hb-parks.sqlite"),
            threadPool: threadPool,
            eventLoopGroup: eventLoopGroup,
            logger: logger
        )

        try await db.execute(
            .init(unsafeSQL:
                           """
                           CREATE TABLE IF NOT EXISTS parks (
                               "id" uuid PRIMARY KEY,
                               "latitude" double NOT NULL,
                               "longitude" double NOT NULL,
                               "name" text NOT NULL
                           );
                           """
                 )
        )
    }
}
