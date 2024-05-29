import SwiftUI
import PencilKit

struct DrawingView: View {
    @Binding var drawing: UIImage?
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var isShareSheetPresented = false

    var body: some View {
        NavigationView {
            VStack {
                TextField("Title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Description", text: $description)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                CanvasView(drawing: $drawing)
                    .background(Color.white)
                    .navigationBarItems(trailing: HStack {
                        Button(action: saveDrawing) {
                            Image(systemName: "square.and.arrow.down")
                        }
                        Button(action: {
                            isShareSheetPresented = true
                        }) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    })
                    .sheet(isPresented: $isShareSheetPresented) {
                        if let drawing = drawing {
                            ShareSheet(activityItems: [drawing])
                        }
                    }
            }
        }
    }

    func saveDrawing() {
        guard let drawing = drawing, !title.isEmpty, !description.isEmpty else { return }
        let imageName = UUID().uuidString + ".png"
        let doodle = SavedDoodle(id: UUID().uuidString, title: title, description: description, imageName: imageName)
        StorageManager.shared.saveDoodle(doodle, image: drawing)
    }
}

struct CanvasView: UIViewRepresentable {
    @Binding var drawing: UIImage?

    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        canvas.delegate = context.coordinator
        canvas.drawingPolicy = .anyInput
        canvas.tool = PKInkingTool(.pen, color: .black, width: 10)
        return canvas
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(drawing: $drawing)
    }

    class Coordinator: NSObject, PKCanvasViewDelegate {
        @Binding var drawing: UIImage?

        init(drawing: Binding<UIImage?>) {
            self._drawing = drawing
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            self.drawing = canvasView.drawing.image(from: canvasView.bounds, scale: UIScreen.main.scale)
        }
    }
}
