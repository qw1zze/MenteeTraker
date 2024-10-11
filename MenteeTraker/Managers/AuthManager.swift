import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore

final class AuthManager {
    static let instance = AuthManager()
    
    private init() {}
    
    
    /// A method to register the user
    /// - Parameters:
    ///   - userRequest: A user information
    ///   - completion: A completion with 2 values
    public func registerUser(with userRequest: RegisterUserRequest, completion: @escaping (Bool, Error?)->Void) {
        let name = userRequest.name.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = userRequest.email.lowercased()
        let password = userRequest.password
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let userResult = result?.user else {
                completion(false, nil)
                return
            }
            
            let db = Database.database().reference()
            
            db.child("users").child(result!.user.uid).setValue(["name": name, "email": email, "role": "trainee", "mentor": " "]) {error, _ in
                if let error = error {
                    completion(false, error)
                    return
                }
                completion(true, nil)
            }
        }
    }
    
    public func signIn(with userRequest: LoginUserRequest, completion: @escaping (Error?)->Void) {
        Auth.auth().signIn(withEmail: userRequest.email, password: userRequest.password) { result, error in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    public func insertEmail(with email: String, completion: @escaping (Error?)->Void) {
        Auth.auth().currentUser!.sendEmailVerification(beforeUpdatingEmail: email) { error in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    public func insertPassword(with pass: String, completion: @escaping (Error?)->Void) {
        Auth.auth().currentUser!.updatePassword(to: pass) { error in
            if let error = error {
                completion(error)
                return
            }
        }
        completion(nil)
    }
    
    public func signOut(completion: @escaping (Error?)->Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
    var isSigned: Bool {
        return Auth.auth().currentUser != nil
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExpiration: Date? {
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false
    }
}
