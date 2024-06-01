import SwiftUI
import FirebaseStorage

struct SavedDoodlesView: View {
    @Binding var savedDoodles: [SavedDoodle]

    var body: some View {
        NavigationView {
            List(savedDoodles) { doodle in
                HStack {
                    if let imageURL = getImageURL(from: doodle.imageName) {
                        AsyncImage(url: imageURL) { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .cornerRadius(5)
                        } placeholder: {
                            ProgressView()
                        }
                    }

                    VStack(alignment: .leading) {
                        Text(doodle.title)
                            .font(.headline)
                        Text(doodle.description)
                            .font(.subheadline)
                        Text("by \(doodle.username)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Saved Doodles")
        }
    }

    private func getImageURL(from imageName: String) -> URL? {
        let storageRef = Storage.storage().reference().child(imageName)
        var imageURL: URL?

        let semaphore = DispatchSemaphore(value: 0)
        storageRef.downloadURL { url, error in
            if let error = error {
                print("Error getting download URL: \(error.localizedDescription)")
            } else {
                imageURL = url
            }
            semaphore.signal()
        }

        _ = semaphore.wait(timeout: .now() + 10)
        return imageURL
    }
}
