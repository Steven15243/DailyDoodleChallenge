import SwiftUI
import Firebase

@main
struct DailyDoodleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            UserAuthenticationView()
                .environmentObject(AuthManager())
        }
    }
}
