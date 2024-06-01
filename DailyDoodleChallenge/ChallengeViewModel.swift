import Foundation

class ChallengeViewModel: ObservableObject {
    @Published var currentChallenge = DoodleChallenge(title: "Daily Doodle", description: "Draw something awesome today!")

    func loadDailyChallenge() {
        // In a real app, you would load a new challenge from your server or database.
        // Here we just use a static challenge for simplicity.
        currentChallenge = DoodleChallenge(title: "Daily Doodle", description: "Draw something awesome today!")
    }
}
