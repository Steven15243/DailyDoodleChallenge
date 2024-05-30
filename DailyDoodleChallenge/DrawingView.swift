import SwiftUI
import PencilKit

struct DrawingView: UIViewRepresentable {
    @Binding var drawing: PKDrawing?

    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: DrawingView

        init(parent: DrawingView) {
            self.parent = parent
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            parent.drawing = canvasView.drawing
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.drawingPolicy = .anyInput
        canvasView.delegate = context.coordinator
        canvasView.isOpaque = false
        canvasView.backgroundColor = UIColor.clear
        canvasView.drawing = drawing ?? PKDrawing()
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.drawing = drawing ?? PKDrawing()
    }
}
