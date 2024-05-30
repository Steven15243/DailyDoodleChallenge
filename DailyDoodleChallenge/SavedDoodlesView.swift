import SwiftUI

struct SavedDoodlesView: View {
    @Binding var savedDoodles: [SavedDoodle]

    var body: some View {
        NavigationView {
            List(savedDoodles) { doodle in
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
                    } else {
                        Text("Image not available")
                            .foregroundColor(.red)
                    }
                }
                .padding()
            }
            .navigationTitle("Saved Doodles")
        }
    }
}

struct SavedDoodlesView_Previews: PreviewProvider {
    @State static var savedDoodles: [SavedDoodle] = [
        SavedDoodle(id: UUID().uuidString, title: "Sample Doodle", description: "This is a sample doodle.", imageName: "")
    ]

    static var previews: some View {
        SavedDoodlesView(savedDoodles: $savedDoodles)
    }
}
