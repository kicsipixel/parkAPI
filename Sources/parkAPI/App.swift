import ArgumentParser
import Hummingbird

@main
struct App: AsyncParsableCommand, AppArguments {
    
    @Option(name: .shortAndLong)
    var hostname: String = "127.0.0.1"
    
    @Option(name: .shortAndLong)
    var port: Int = 8080
    
    func run() async throws {
        let app = HBApplication(
            configuration: .init(
                address: .hostname(hostname, port: port),
                serverName: "parkAPI"
            )
        )
        
        try await app.configure()
        try app.start()
        app.wait()
    }
}
