import SwiftUI
import Firebase
import PencilKit

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    @StateObject private var viewModel = ChallengeViewModel()
    @State private var showingDrawingView = false
    @State private var showingSavedDoodles = false
    @State private var savedDoodles: [SavedDoodle] = []
    @State private var currentDrawing = PKDrawing()

    var body: some View {
        NavigationView {
            ZStack {
                // Background Image
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer()

                    // Title
                    Text(viewModel.currentChallenge.title)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                        .padding(.bottom, 10)

                    // Description
                    Text(viewModel.currentChallenge.description)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                        .padding(.bottom, 20)

                    // Buttons
                    Button(action: {
                        showingDrawingView = true
                    }) {
                        Text("Start Drawing")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .top, endPoint: .bottom))
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                    .padding(.bottom, 10)

                    Button(action: {
                        showingSavedDoodles = true
                        loadSavedDoodles()
                    }) {
                        Text("Community Doodles")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .top, endPoint: .bottom))
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                    .padding(.bottom, 30)

                    Spacer()

                    // Display username if available
                    if let displayName = authManager.user?.displayName {
                        Text("Logged in as \(displayName)")
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .padding()
            }
            .sheet(isPresented: $showingDrawingView) {
                DrawingControlsView(drawing: $currentDrawing)
                    .environmentObject(authManager)
            }
            .sheet(isPresented: $showingSavedDoodles) {
                SavedDoodlesView(savedDoodles: $savedDoodles)
                    .environmentObject(authManager)
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
            .environmentObject(AuthManager())
            .environmentObject(ChallengeViewModel())
    }
}
