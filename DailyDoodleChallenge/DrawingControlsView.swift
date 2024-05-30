import SwiftUI
import PencilKit

struct DrawingControlsView: View {
    @Binding var drawing: PKDrawing?
    @Environment(\.presentationMode) var presentationMode
    @State private var title: String = ""
    @State private var description: String = ""
    
    var body: some View {
        VStack {
            if let drawing = drawing {
                PKCanvasViewWrapper(drawing: $drawing)
            } else {
                Text("Start drawing!")
                    .font(.largeTitle)
                    .padding()
            }
            
            // Text fields for title and description
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
    }
    
    private func saveDrawing() {
        guard let drawing = drawing else { return }
        let image = drawing.image(from: drawing.bounds, scale: 1.0)
        
        // Use the input title and description
        let savedDoodle = SavedDoodle(id: UUID().uuidString, title: title, description: description, imageName: "")
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
        guard let drawing = drawing else { return }
        let image = drawing.image(from: drawing.bounds, scale: 1.0)
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        // Ensure presentation happens on the main thread
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                // Check if there is a presented view controller
                if rootViewController.presentedViewController == nil {
                    rootViewController.present(activityController, animated: true, completion: nil)
                } else {
                    // Dismiss any presented view controller before presenting the new one
                    rootViewController.dismiss(animated: true) {
                        rootViewController.present(activityController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
