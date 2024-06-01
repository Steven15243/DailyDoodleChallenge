import Firebase
import FirebaseStorage
import UIKit

class StorageManager {
    static let shared = StorageManager()
    private let storage = Storage.storage()

    func saveDoodle(_ doodle: SavedDoodle, image: UIImage, completion: @escaping (Bool) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(false)
            return
        }

        let imageRef = storage.reference().child("doodles/\(doodle.id ?? UUID().uuidString).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        imageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(false)
                return
            }

            imageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    completion(false)
                    return
                }

                guard let downloadURL = url else {
                    print("Failed to retrieve a download URL.")
                    completion(false)
                    return
                }

                print("Image uploaded successfully. Download URL: \(downloadURL.absoluteString)")

                var savedDoodle = doodle
                savedDoodle.imageUrl = downloadURL.absoluteString

                // Save the doodle to Firestore
                do {
                    try Firestore.firestore().collection("doodles").document(savedDoodle.id ?? UUID().uuidString).setData(from: savedDoodle)
                    print("Doodle saved to Firestore with URL: \(savedDoodle.imageUrl ?? "No URL")")
                    completion(true)
                } catch {
                    print("Error saving doodle to Firestore: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }

    func fetchDoodles(completion: @escaping ([SavedDoodle]) -> Void) {
        Firestore.firestore().collection("doodles").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching doodles: \(error.localizedDescription)")
                completion([])
                return
            }

            let doodles = snapshot?.documents.compactMap { document -> SavedDoodle? in
                try? document.data(as: SavedDoodle.self)
            } ?? []

            completion(doodles)
        }
    }

    func fetchImage(for doodle: SavedDoodle, completion: @escaping (UIImage?) -> Void) {
        guard let imageUrl = doodle.imageUrl, let url = URL(string: imageUrl) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching image: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }

            completion(image)
        }

        task.resume()
    }
}
