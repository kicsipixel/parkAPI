import Hummingbird
import HummingbirdFoundation

public extension HBApplication {

    func configure() throws {

        router.get("/") { _ in
            "Hello, world!"
        }
    }
}
