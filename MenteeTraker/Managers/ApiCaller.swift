import UIKit
import Firebase
import FirebaseDatabase

final class ApiCaller {
    
    static let instance = ApiCaller()
    let DB = Database.database().reference()
    
    func ifExists(uid: String, completion: @escaping(Bool) -> Void) {
        DB.child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else {completion(false); return}
            completion(true)
        }
    }
    
    func getUserInfo(uid: String, completion: @escaping(UserInfo) -> Void) {
        self.ifExists(uid: uid) { ans in
            if ans {
                self.DB.child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
                    guard let dict = snapshot.value as? [String: Any] else {return}
                    
                    let userInfo = UserInfo(key: uid, dict: dict)
                    completion(userInfo)
                }
            } else {
                completion(UserInfo(key: "", dict: ["": ""]))
            }
        }
    }
    
    func getAllTrainees(uidMentor: String, completion: @escaping([String]) -> Void) {
        var traines = [String]()
        
        DB.child("users").observe(.childAdded) { (snapshot) in
            self.getUserInfo(uid: snapshot.key) { (user) in
                if user.mentor == uidMentor {
                    traines.append(user.email)
                    completion(traines)
                }
            }
        }
        completion(traines)
    }
    
    func getCountTrainee(uidMentor: String, completion: @escaping(Int) -> Void) {
        var count = 0
        
        DB.child("users").observe(.childAdded) { (snapshot) in
            self.getUserInfo(uid: snapshot.key) { (user) in
                if user.mentor == uidMentor {
                    count += 1
                    completion(count)
                }
            }
        }
        completion(count)
    }
    
    func getUserByEmail(email: String, completion: @escaping(String, Bool) -> Void) {
        DB.child("users").observe(.childAdded) { (snapshot) in
            self.getUserInfo(uid: snapshot.key) { (user) in
                if user.email == email {
                    completion(snapshot.key, true)
                }
            }
            completion(snapshot.key, false)
        }
    }
    
    func getAllUserTasks(uidUser: String, completion: @escaping([TaskShort]) -> Void) {
        
        var tasks = [TaskShort]()
        
        DB.child("tasks").observe(.childAdded) { (snapshot) in
            self.getTask(uid: snapshot.key) { (task) in
                if task.trainee == uidUser {
                    tasks.append(task)
                    completion(tasks)
                }
            }
        }
    }
    
    func getAllUserTasksByMentor(uidMentor: String, completion: @escaping([TaskShort]) -> Void) {
        
        var tasks = [TaskShort]()
        
        DB.child("tasks").observe(.childAdded) { (snapshot) in
            self.getTask(uid: snapshot.key) { (task) in
                if task.mentor == uidMentor {
                    tasks.append(task)
                    completion(tasks)
                }
            }
        }
    }
    
    func getAllTaskAnswers(uidTask: String, completion: @escaping([TaskAnswer]) -> Void){
        var tasks = [TaskAnswer]()
        
        DB.child("tasks").child(uidTask).child("answers").observe(.childAdded) { (snapshot) in
            self.getTaskAnswer(uidTask: uidTask, uidAns: snapshot.key) { (task) in
                tasks.append(task)
                completion(tasks)
            }
        }
    }
    
    func getTaskAnswer(uidTask: String, uidAns: String, completion: @escaping(TaskAnswer) -> Void) {
        DB.child("tasks").child(uidTask).child("answers").child(uidAns).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else {return}

            let taskAnswer = TaskAnswer(key: uidAns, dict: dict)
            completion(taskAnswer)
        }
    }
    
    func getCountTask(uidUser: String, completion: @escaping(Int) -> Void) {
        var tasks = 0
        
        DB.child("tasks").observe(.childAdded) { (snapshot) in
            self.getTask(uid: snapshot.key) { (task) in
                var rev = String(task.deadline.reversed())
                
                if task.trainee == uidUser && !task.isReady() {
                    tasks += 1
                    completion(tasks)
                }
            }
        }
        completion(tasks)
    }
    
    func getTask(uid: String, completion: @escaping(TaskShort) -> Void) {
        DB.child("tasks").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else {return}
            
            let taskShort = TaskShort(key: uid, dict: dict)
            completion(taskShort)
        }
    }
    
    func getNameDDTask(uidTask: String, completion: @escaping(String, String) -> Void) {
        DB.child("tasks").child(uidTask).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else {return}
            
            let taskShort = TaskShort(key: uidTask, dict: dict)
            completion(taskShort.name, taskShort.deadline)
        }
    }
    
    func addAnswerToTask(uidTask: String, text: String, completion: @escaping (Bool, Error?)->Void) {
        
        ApiCaller.instance.getUserInfo(uid: Auth.auth().currentUser!.uid) { (userInfo) in
            
            self.DB.child("tasks").child(uidTask).child("answers").childByAutoId().setValue(["last": true, "text": text, "who":  userInfo.role]) {error, _ in
                if let error = error {
                    completion(false, error)
                    return
                }
                completion(true, nil)
            }
        }
    }
    
    func addTask(uidTrainee: String, taskName: String, deadline: String, completion: @escaping (Bool, Error?, String)->Void) {
        ApiCaller.instance.getUserInfo(uid: uidTrainee) { (traineeInfo) in
            
            let newEl = self.DB.child("tasks").childByAutoId()
            let key = newEl.key!
            
            newEl.setValue(["uidMentor": Auth.auth().currentUser!.uid, "uidTrainee": uidTrainee, "traineeName": traineeInfo.name, "taskName": taskName, "status": "todo", "deadline": deadline]) {error, _ in
                if let error = error {
                    completion(false, error, key)
                    return
                }
                completion(true, nil, key)
            }
        }
    }
    
    func setAnswerNotLast(uidTask: String, uidAnswer: String, completion: @escaping (Bool, Error?)->Void) {
        self.DB.child("tasks").child(uidTask).child("answers").child(uidAnswer).updateChildValues(["last" : false], withCompletionBlock: { (error, _) in
            if let error = error {
                completion(false, error)
                return
            }
            completion(true, nil)
        })
    }
    
    func completeTask(uidTask: String, completion: @escaping (Bool, Error?)->Void) {
        self.DB.child("tasks").child(uidTask).updateChildValues(["status" : "ready"], withCompletionBlock: { (error, _) in
            if let error = error {
                completion(false, error)
                return
            }
            completion(true, nil)
        })
    }
    
    func toReviewTask(uidTask: String, completion: @escaping (Bool, Error?)->Void) {
        self.DB.child("tasks").child(uidTask).updateChildValues(["status" : "checking"], withCompletionBlock: { (error, _) in
            if let error = error {
                completion(false, error)
                return
            }
            completion(true, nil)
        })
    }
    
    func toDo(uidTask: String, completion: @escaping (Bool, Error?)->Void) {
        self.DB.child("tasks").child(uidTask).updateChildValues(["status" : "todo"], withCompletionBlock: { (error, _) in
            if let error = error {
                completion(false, error)
                return
            }
            completion(true, nil)
        })
    }
    
    func setMentor(uidMentor: String, emailTrainee: String, completion: @escaping (Bool, Error?)->Void) {
        DB.child("users").observe(.childAdded) { (snapshot) in
            self.getUserInfo(uid: snapshot.key, completion: { (info) in
                if info.role == "trainee" && info.mentor == " " {
                    self.DB.child("users").child(snapshot.key).updateChildValues(["mentor": uidMentor]) { (error, _) in
                        if let error = error {
                            completion(false, error)
                            return
                        }
                        completion(true, nil)
                    }
                }
            })
            completion(false, nil)
        }
    }
    
    func changeEmail(uidUser: String, email: String, completion: @escaping (Bool, Error?)->Void) {
        self.DB.child("users").child(uidUser).updateChildValues(["email" : email], withCompletionBlock: { (error, _) in
            if let error = error {
                completion(false, error)
                return
            }
            completion(true, nil)
        })
    }
}
