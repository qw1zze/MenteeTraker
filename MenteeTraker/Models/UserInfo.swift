import Foundation

struct UserInfo {
    var name: String
    var role: String
    var email: String
    var mentor: String
    
    init(key: String, dict: [String: Any]) {
        self.name = dict["name"] as? String ?? ""
        self.role = dict["role"] as? String ?? ""
        self.email = dict["email"] as? String ?? ""
        self.mentor = dict["mentor"] as? String ?? ""
    }
}
