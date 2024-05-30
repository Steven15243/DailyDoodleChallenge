import SwiftUI
import Combine

struct Challenge {
    var title: String
    var description: String
}

class ChallengeViewModel: ObservableObject {
    @Published var currentChallenge: Challenge

    init() {
        self.currentChallenge = Challenge(title: "Daily Doodle", description: "Draw something amazing!")
        generateNewChallenge()
    }

    func generateNewChallenge() {
        // Here you can generate a new challenge, for now, let's keep it static
        currentChallenge = Challenge(title: "New Challenge", description: "Draw a beautiful landscape!")
    }
}
