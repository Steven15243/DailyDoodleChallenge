import SwiftUI
import PencilKit

struct PKCanvasViewWrapper: UIViewRepresentable {
    @Binding var drawing: PKDrawing?

    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: PKCanvasViewWrapper

        init(parent: PKCanvasViewWrapper) {
            self.parent = parent
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            parent.drawing = canvasView.drawing
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.delegate = context.coordinator
        canvasView.drawing = drawing ?? PKDrawing()
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 15)
        canvasView.backgroundColor = .white
        canvasView.allowsFingerDrawing = true // Allow finger drawing
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.drawing = drawing ?? PKDrawing()
        uiView.tool = PKInkingTool(.pen, color: .black, width: 15)
    }
}
