import SwiftUI

struct UserAuthenticationView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var isLoginMode = true
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            if isLoginMode {
                Text("Login")
                    .font(.largeTitle)
                    .padding(.bottom, 20)

                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                    .padding(.bottom, 20)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                    .padding(.bottom, 20)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.bottom, 20)
                }

                Button("Login") {
                    authManager.signIn(email: email, password: password) { result in
                        switch result {
                        case .success(_):
                            break
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                        }
                    }
                }
                .padding()

                Button("Don't have an account? Sign Up") {
                    isLoginMode = false
                }
                .padding()

            } else {
                Text("Sign Up")
                    .font(.largeTitle)
                    .padding(.bottom, 20)

                TextField("Username", text: $username)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                    .padding(.bottom, 20)

                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                    .padding(.bottom, 20)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                    .padding(.bottom, 20)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.bottom, 20)
                }

                Button("Sign Up") {
                    authManager.signUp(email: email, password: password, username: username) { result in
                        switch result {
                        case .success(_):
                            break
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                        }
                    }
                }
                .padding()

                Button("Already have an account? Login") {
                    isLoginMode = true
                }
                .padding()
            }
        }
        .padding()
        .fullScreenCover(isPresented: $authManager.isAuthenticated) {
            ContentView()
                .environmentObject(authManager)
        }
    }
}
