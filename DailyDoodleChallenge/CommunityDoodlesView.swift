import SwiftUI

struct CommunityDoodlesView: View {
    @State private var doodles: [SavedDoodle] = []
    @State private var selectedDoodle: SavedDoodle?
    @State private var selectedImage: UIImage?
    @State private var isShareSheetPresented = false

    var body: some View {
        NavigationView {
            List(doodles) { doodle in
                VStack(alignment: .leading) {
                    Text(doodle.title)
                        .font(.headline)
                    Text(doodle.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    if let url = URL(string: doodle.imageName), let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) {
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
                        Text("Image not available")
                            .foregroundColor(.red)
                    }
                }
                .padding()
            }
            .navigationTitle("Community Doodles")
            .onAppear {
                loadDoodles()
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

    private func loadDoodles() {
        StorageManager.shared.fetchDoodles { doodles in
            self.doodles = doodles
        }
    }
}

struct CommunityDoodlesView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityDoodlesView()
    }
}
