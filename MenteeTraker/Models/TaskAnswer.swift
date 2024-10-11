import Foundation

struct TaskAnswer {
    var uidAnswer: String
    var text: String
    var who: String
    var last: Bool
    
    init(key: String, dict: [String: Any]) {
        self.uidAnswer = key
        self.text = dict["text"] as? String ?? ""
        self.who = dict["who"] as? String ?? ""
        self.last = dict["last"] as? Bool ?? false
    }
}
