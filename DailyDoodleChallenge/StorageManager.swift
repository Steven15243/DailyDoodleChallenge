import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

class StorageManager {
    static let shared = StorageManager()
    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    func saveDoodle(_ doodle: SavedDoodle, image: UIImage, completion: @escaping (Bool) -> Void) {
        guard let data = image.pngData() else {
            completion(false)
            return
        }

        let imageName = UUID().uuidString + ".png"
        let storageRef = storage.reference().child("doodles/\(imageName)")

        storageRef.putData(data, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error)")
                completion(false)
                return
            }

            storageRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    print("Error getting download URL: \(error?.localizedDescription ?? "")")
                    completion(false)
                    return
                }

                var doodleData = doodle
                doodleData.imageName = downloadURL.absoluteString
                self.db.collection("drawings").addDocument(data: [
                    "id": doodleData.id,
                    "title": doodleData.title,
                    "description": doodleData.description,
                    "imageName": doodleData.imageName
                ]) { error in
                    if let error = error {
                        print("Error saving doodle: \(error)")
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            }
        }
    }

    func fetchDoodles(completion: @escaping ([SavedDoodle]) -> Void) {
        db.collection("drawings").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching doodles: \(error)")
                completion([])
                return
            }

            let doodles = snapshot?.documents.compactMap { doc -> SavedDoodle? in
                let data = doc.data()
                guard let id = data["id"] as? String,
                      let title = data["title"] as? String,
                      let description = data["description"] as? String,
                      let imageName = data["imageName"] as? String else { return nil }

                return SavedDoodle(id: id, title: title, description: description, imageName: imageName)
            } ?? []

            completion(doodles)
        }
    }
}
