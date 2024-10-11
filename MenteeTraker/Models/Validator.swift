import Foundation

class Validator {
    
    static func isValidEmail(for email: String) -> Bool {
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.{1}[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPred.evaluate(with: email)
    }
    
    static func isValidName(for name: String) -> Bool {
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let nameRegex = "^[A-Za-zА-Яа-я\\s-]+$"
        let namePred = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return namePred.evaluate(with: name)
    }
    
    static func isPasswordValid(for password: String) -> Bool {
        let password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let nameRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[$@$#!%*?&]).{6,32}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return passwordPred.evaluate(with: password)
    }
}
