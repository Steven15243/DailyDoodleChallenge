import SwiftUI
import PencilKit

struct DrawingView: View {
    @Binding var drawing: PKDrawing

    var body: some View {
        PKCanvasViewWrapper(drawing: $drawing)
    }
}
