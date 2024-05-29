import Foundation
import SwiftUI

class ChallengeViewModel: ObservableObject {
    @Published var currentChallenge: DoodleChallenge
    @Published var drawing: UIImage?

    private var challenges: [DoodleChallenge] = [
        DoodleChallenge(title: "Draw a Cat", description: "Draw a cute cat."),
        DoodleChallenge(title: "Draw a House", description: "Draw your dream house."),
        DoodleChallenge(title: "Draw a Tree", description: "Draw a beautiful tree."),
        // Add more challenges here
    ]

    init() {
        self.currentChallenge = challenges.randomElement()!
    }

    func getRandomChallenge() {
        self.currentChallenge = challenges.randomElement()!
    }
}
