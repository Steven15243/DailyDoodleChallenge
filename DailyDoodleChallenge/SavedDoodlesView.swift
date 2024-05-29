import SwiftUI

struct SavedDoodlesView: View {
    @State private var savedDoodles: [SavedDoodle] = []
    @State private var selectedDoodle: SavedDoodle?
    @State private var selectedImage: UIImage?
    @State private var isShareSheetPresented = false

    var body: some View {
        NavigationView {
            List(savedDoodles) { doodle in
                VStack(alignment: .leading) {
                    Text(doodle.title)
                        .font(.headline)
                    Text(doodle.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    if let image = StorageManager.shared.loadImage(withName: doodle.imageName) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .onTapGesture {
                                selectedDoodle = doodle
                                selectedImage = image
                                isShareSheetPresented = true
                            }
                    } else {
                        Text("Image not found")
                            .foregroundColor(.red)
                    }
                }
                .padding()
            }
            .navigationTitle("Saved Doodles")
            .onAppear {
                loadSavedDoodles()
            }
            .sheet(isPresented: $isShareSheetPresented) {
                if let image = selectedImage, let doodle = selectedDoodle {
                    ShareSheet(activityItems: [image, "\(doodle.title)\n\(doodle.description)"])
                } else {
                    Text("No image to share")
                }
            }
        }
    }

    private func loadSavedDoodles() {
        savedDoodles = StorageManager.shared.getSavedDoodles()
    }
}

struct SavedDoodlesView_Previews: PreviewProvider {
    static var previews: some View {
        SavedDoodlesView()
    }
}
