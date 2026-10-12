import SwiftUI

@main
struct CollabMNApp: App {
    @StateObject private var authManager = AuthManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
                .environmentObject(DataStore.shared)
                .preferredColorScheme(.dark)
        }
    }
}

