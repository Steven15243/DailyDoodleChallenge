import SwiftUI
import PencilKit

struct DrawingControlsView: View {
    @Binding var drawing: PKDrawing
    @Environment(\.presentationMode) var presentationMode
    @State private var title: String = ""
    @State private var description: String = ""
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        VStack {
            PKCanvasViewWrapper(drawing: $drawing)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding()

            TextField("Enter title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Enter description", text: $description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            HStack {
                Button(action: saveDrawing) {
                    Text("Save")
                }
                .padding()

                Button(action: shareDrawing) {
                    Text("Share")
                }
                .padding()
            }
        }
        .padding()
    }

    private func saveDrawing() {
        let image = drawing.image(from: drawing.bounds, scale: 1.0)

        guard let user = authManager.user else { return }
        let savedDoodle = SavedDoodle(
            id: UUID().uuidString,
            title: title,
            description: description,
            imageName: "",
            username: user.displayName ?? "Unknown"
        )

        StorageManager.shared.saveDoodle(savedDoodle, image: image) { success in
            if success {
                NotificationCenter.default.post(name: NSNotification.Name("DoodleSaved"), object: nil)
                presentationMode.wrappedValue.dismiss()
            } else {
                print("Error saving doodle")
            }
        }
    }

    private func shareDrawing() {
        let image = drawing.image(from: drawing.bounds, scale: 1.0)
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)

        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                if rootViewController.presentedViewController == nil {
                    rootViewController.present(activityController, animated: true, completion: nil)
                } else {
                    rootViewController.dismiss(animated: true) {
                        rootViewController.present(activityController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
