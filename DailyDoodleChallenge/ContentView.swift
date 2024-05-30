import SwiftUI
import PencilKit

struct ContentView: View {
    @StateObject private var viewModel = ChallengeViewModel()
    @State private var showingDrawingView = false
    @State private var showingSavedDoodles = false
    @State private var showingCommunityDoodles = false
    @State private var savedDoodles: [SavedDoodle] = []
    @State private var currentDrawing: PKDrawing? = PKDrawing()

    var body: some View {
        NavigationView {
            VStack {
                Text(viewModel.currentChallenge.title)
                    .font(.largeTitle)
                    .padding()
                Text(viewModel.currentChallenge.description)
                    .font(.subheadline)
                    .padding()
                Button("Start Drawing") {
                    showingDrawingView = true
                }
                .padding()
                Button("Saved Doodles") {
                    showingSavedDoodles = true
                    loadSavedDoodles()
                }
                .padding()
                Button("Community Doodles") {
                    showingCommunityDoodles = true
                }
                .padding()
            }
            .sheet(isPresented: $showingDrawingView) {
                DrawingControlsView(drawing: $currentDrawing)
            }
            .sheet(isPresented: $showingSavedDoodles) {
                SavedDoodlesView(savedDoodles: $savedDoodles)
            }
            .sheet(isPresented: $showingCommunityDoodles) {
                CommunityDoodlesView()
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("DoodleSaved"), object: nil, queue: .main) { _ in
                loadSavedDoodles()
            }
            viewModel.loadDailyChallenge()
        }
    }

    private func loadSavedDoodles() {
        StorageManager.shared.fetchDoodles { doodles in
            self.savedDoodles = doodles
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
