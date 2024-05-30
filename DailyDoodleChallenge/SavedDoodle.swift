import Foundation

struct SavedDoodle: Identifiable, Codable {
    var id: String
    var title: String
    var description: String
    var imageName: String
}
