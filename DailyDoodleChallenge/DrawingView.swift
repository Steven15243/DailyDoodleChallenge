import SwiftUI
import PencilKit

struct DrawingView: View {
    @Binding var drawing: UIImage?

    var body: some View {
        NavigationView {
            CanvasView(drawing: $drawing)
                .background(Color.white)
                .navigationBarItems(trailing: Button(action: saveDrawing) {
                    Image(systemName: "square.and.arrow.up")
                })
        }
    }

    func saveDrawing() {
        guard let drawing = drawing else { return }
        let activityVC = UIActivityViewController(activityItems: [drawing], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
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
