import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ChallengeViewModel()
    @State private var showingDrawingView = false

    var body: some View {
        NavigationView {
            VStack {
                Text(viewModel.currentChallenge.title)
                    .font(.largeTitle)
                    .padding()
                Text(viewModel.currentChallenge.description)
                    .font(.subheadline)
                    .padding()

                Button(action: {
                    viewModel.getRandomChallenge()
                }) {
                    Text("Get New Challenge")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                Button(action: {
                    showingDrawingView = true
                }) {
                    Text("Draw Now")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .sheet(isPresented: $showingDrawingView) {
                DrawingView(drawing: $viewModel.drawing)
            }
            .navigationTitle("Daily Doodle Challenge")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}