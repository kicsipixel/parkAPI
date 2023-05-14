import Hummingbird
import HummingbirdFoundation

// TODO: co to je?
public protocol AppArguments {}

public extension HBApplication {

    func configure() throws {

        router.get("/") { _ in
            "Hello, world!"
        }
    }
}
