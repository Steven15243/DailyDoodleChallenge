import Foundation
import FirebaseFirestoreSwift

struct SavedDoodle: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var imageName: String
    var imageUrl: String? // Add this property
    var username: String
}
