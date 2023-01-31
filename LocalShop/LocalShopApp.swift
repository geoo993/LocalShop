import SwiftUI

@main
struct LocalShopApp: App {
    @Environment(\.scenePhase) var scenePhase
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onChange(of: scenePhase) { _ in
                    persistenceController.save()
                }
        }
    }
}
