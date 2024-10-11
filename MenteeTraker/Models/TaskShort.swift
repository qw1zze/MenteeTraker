import Foundation

struct TaskShort {
    var uid: String
    var name: String
    var deadline: String
    var mentor: String
    var trainee: String
    var status: String
    var traineeName: String
    
    init(key: String, dict: [String: Any]) {
        self.uid = key
        self.name = dict["taskName"] as? String ?? ""
        self.mentor = dict["uidMentor"] as? String ?? ""
        self.deadline = dict["deadline"] as? String ?? ""
        self.trainee = dict["uidTrainee"] as? String ?? ""
        self.status = dict["status"] as? String ?? ""
        self.traineeName = dict["traineeName"] as? String ?? ""
    }
    
    
    func isReady() -> Bool {
        return status == "ready"
    }
    
    func isToDo() -> Bool {
        return status == "todo"
    }
    
    func isChecking() -> Bool {
        return status == "checking"
    }
    
    static func printStatus(status: String) -> String{
        if status == "ready" {
            return "Completed"
        } else if status == "todo" {
            return "On work"
        } else if status == "checking" {
            return "On review"
        }
        return ""
    }
}
