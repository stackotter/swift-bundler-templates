import SwiftCrossUI
import DefaultBackend

@main
struct HelloWorldApp: App {
    let identifier = "com.example.HelloWorld"

    var body: some Scene {
        WindowGroup("HelloWorld") {
            Text("Hello, World!")
                .padding(10)
        }
    }
}
