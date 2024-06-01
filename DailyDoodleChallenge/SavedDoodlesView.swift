import SwiftUI

struct SavedDoodlesView: View {
    @Binding var savedDoodles: [SavedDoodle]
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        NavigationView {
            List(savedDoodles) { doodle in
                VStack(alignment: .leading) {
                    if let imageUrl = doodle.imageUrl, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 100, height: 100)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            case .failure:
                                Image(systemName: "xmark.octagon.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    }

                    Text(doodle.title)
                        .font(.headline)
                    Text(doodle.description)
                        .font(.subheadline)
                    Text("By: \(doodle.username)")
                        .font(.caption)
                }
            }
            .navigationTitle("Saved Doodles")
        }
    }
}
