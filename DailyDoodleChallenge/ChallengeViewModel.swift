import SwiftUI
import Combine

class ChallengeViewModel: ObservableObject {
    @Published var currentChallenge: Challenge
    
    private let challengeKey = "currentChallenge"
    private let lastGeneratedDateKey = "lastGeneratedDate"
    
    init() {
        self.currentChallenge = Challenge(title: "Welcome!", description: "Start a new challenge!")
        loadDailyChallenge()
    }
    
    func generateNewChallenge() {
        let newChallenge = generateChallengeForToday()
        self.currentChallenge = newChallenge
        saveChallenge(newChallenge)
    }
    
    func loadDailyChallenge() { // Changed to internal
        let lastGeneratedDate = UserDefaults.standard.object(forKey: lastGeneratedDateKey) as? Date ?? Date.distantPast
        if !Calendar.current.isDateInToday(lastGeneratedDate) {
            let newChallenge = generateChallengeForToday()
            self.currentChallenge = newChallenge
            UserDefaults.standard.set(Date(), forKey: lastGeneratedDateKey)
            saveChallenge(newChallenge)
        } else {
            loadChallenge()
        }
    }
    
    private func saveChallenge(_ challenge: Challenge) {
        do {
            let data = try JSONEncoder().encode(challenge)
            UserDefaults.standard.set(data, forKey: challengeKey)
        } catch {
            print("Error saving challenge: \(error)")
        }
    }
    
    private func loadChallenge() {
        guard let data = UserDefaults.standard.data(forKey: challengeKey) else { return }
        do {
            let challenge = try JSONDecoder().decode(Challenge.self, from: data)
            self.currentChallenge = challenge
        } catch {
            print("Error loading challenge: \(error)")
        }
    }
    
    private func generateChallengeForToday() -> Challenge {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: Date())
        
        let seed = dateString.hashValue
        srand48(seed)
        
        // Example logic to generate a challenge
        let titles = ["Draw a cat", "Sketch a tree", "Doodle a car", "Create a face", "Illustrate a house"]
        let descriptions = [
            "Draw a cat doing something funny.",
            "Sketch a tree in your neighborhood.",
            "Doodle a car of the future.",
            "Create a face with unique expressions.",
            "Illustrate a house from your imagination."
        ]
        
        let title = titles[abs(seed) % titles.count]
        let description = descriptions[abs(seed) % descriptions.count]
        
        return Challenge(title: title, description: description)
    }
}

struct Challenge: Codable {
    var title: String
    var description: String
}
