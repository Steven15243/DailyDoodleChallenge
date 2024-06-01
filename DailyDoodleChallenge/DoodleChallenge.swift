import Foundation

struct DoodleChallenge: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
}
