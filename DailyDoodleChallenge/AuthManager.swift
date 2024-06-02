import Firebase
import FirebaseAuth
import SwiftUI

class AuthManager: ObservableObject {
    @Published var user: FirebaseAuth.User?
    @Published var isAuthenticated = false

    init() {
        self.user = Auth.auth().currentUser
        self.isAuthenticated = user != nil
        
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.user = user
                self.isAuthenticated = user != nil
            }
        }
    }

    func signIn(email: String, password: String, completion: @escaping (Result<FirebaseAuth.User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                DispatchQueue.main.async {
                    self.user = user
                    self.isAuthenticated = true
                }
                completion(.success(user))
            }
        }
    }

    func signUp(email: String, password: String, username: String, completion: @escaping (Result<FirebaseAuth.User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = username
                changeRequest.commitChanges { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        DispatchQueue.main.async {
                            self.user = user
                            self.isAuthenticated = true
                        }
                        completion(.success(user))
                    }
                }
            }
        }
    }

    func signOut() throws {
        try Auth.auth().signOut()
        DispatchQueue.main.async {
            self.user = nil
            self.isAuthenticated = false
        }
    }
}
