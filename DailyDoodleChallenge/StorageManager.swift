import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
import UIKit

class StorageManager {
    static let shared = StorageManager()
    private let storage = Storage.storage()
    private let firestore = Firestore.firestore()

    func saveDoodle(_ doodle: SavedDoodle, image: UIImage, completion: @escaping (Bool) -> Void) {
        let imageName = UUID().uuidString
        let storageRef = storage.reference().child("doodles/\(imageName).png")
        guard let imageData = image.pngData() else {
            completion(false)
            return
        }

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(false)
                return
            }

            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    completion(false)
                    return
                }

                guard let url = url else {
                    completion(false)
                    return
                }

                var savedDoodle = doodle
                savedDoodle.imageName = imageName
                savedDoodle.imageUrl = url.absoluteString

                do {
                    try self.firestore.collection("doodles").document(doodle.id ?? UUID().uuidString).setData(from: savedDoodle)
                    completion(true)
                } catch {
                    print("Error saving doodle to Firestore: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }

    func fetchDoodles(completion: @escaping ([SavedDoodle]) -> Void) {
        firestore.collection("doodles").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching doodles: \(error.localizedDescription)")
                completion([])
                return
            }

            guard let documents = snapshot?.documents else {
                completion([])
                return
            }

            let doodles = documents.compactMap { document -> SavedDoodle? in
                try? document.data(as: SavedDoodle.self)
            }

            completion(doodles)
        }
    }
}
