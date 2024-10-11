import UIKit
import FirebaseAuth

class MakeAnswerVC: UIViewController, UITextFieldDelegate {
    
    var uidtask = ""
    var uidAnswer = ""
    
    let textLabel = LabelStyle(text: "Добавить Ответ", font: .systemFont(ofSize: 40))
    let textField = TextFieldStyle(placeholder: "Ответ")
    
    let textView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.isEditable = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 15)
        textView.layer.cornerRadius = 20
        textView.layer.borderWidth = 2
        textView.layer.borderColor = CGColorFromRGB(rgbValue: 0x305FBB)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.dataDetectorTypes = .link
        return textView
    }()
    
    let confirmButton = ButtonStyle(backgroundColor: UIColorFromRGB(rgbValue: 0x305FBB), title: "Отправить")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureTextLabel()
        configureTextField()
        
        configureConfirmButton()
        HideKeyborad()
        
    }
    
    func configureTextLabel() {
        
        view.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
    }
    
    func configureTextField() {
        
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 80),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            textView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    func configureConfirmButton() {
        view.addSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            confirmButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 30),
            confirmButton.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 50),
            confirmButton.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -50),
            confirmButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        confirmButton.addTarget(self, action: #selector(addAnswer), for: .touchUpInside)
    }
    
    func HideKeyborad() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
    }
    
    @objc func addAnswer() {
        ApiCaller.instance.getUserInfo(uid: Auth.auth().currentUser!.uid) { (userInfo) in
            if userInfo.role == "trainee" {
                if self.textView.text == "" {
                    AlertStyle(title: "Нет ответа!", message: "Добавьте ответ", preferredStyle: .alert).showAlert(view: self)
                    return
                }
                
                ApiCaller.instance.addAnswerToTask(uidTask: self.uidtask, text: self.textView.text) { (ans, error) in
                    
                    if let error = error {
                        AlertStyle(title: "Ошибка!", message: "Не удалось добавить ответ", preferredStyle: .alert).showAlert(view: self)
                        return
                    }
                    
                    if ans {
                        
                        ApiCaller.instance.setAnswerNotLast(uidTask: self.uidtask, uidAnswer: self.uidAnswer) { (ans, error) in
                            if let error = error {
                                AlertStyle(title: "Ошибка!", message: "Не удалось изменить состояние прошлых ответов", preferredStyle: .alert).showAlert(view: self)
                                return
                            }
                            
                            if ans {
                                ApiCaller.instance.toReviewTask(uidTask: self.uidtask) { (ans, error) in
                                    if let error = error {
                                        AlertStyle(title: "Ошибка!", message: "Не удалось изменить статус задачи", preferredStyle: .alert).showAlert(view: self)
                                        return
                                    }
                                    
                                    if ans {
                                        self.navigationController?.popViewController(animated: true)
                                    } else {
                                        AlertStyle(title: "Ошибка!", message: "Не удалось изменить статус задачи", preferredStyle: .alert).showAlert(view: self)
                                    }
                                }
                            } else {
                                AlertStyle(title: "Ошибка!", message: "Не удалось изменить состояние прошлых ответов", preferredStyle: .alert).showAlert(view: self)
                            }
                        }
                    } else {
                        AlertStyle(title: "Ошибка!", message: "Не удалось изменить состояние прошлых ответов", preferredStyle: .alert).showAlert(view: self)
                    }
                }
            } else if userInfo.role == "mentor" {
                if self.textView.text == "" {
                    AlertStyle(title: "Нет ответа!", message: "Добавьте ответ", preferredStyle: .alert).showAlert(view: self)
                    return
                }
                
                ApiCaller.instance.addAnswerToTask(uidTask: self.uidtask, text: self.textView.text) { (ans, error) in
                    
                    if let error = error {
                        AlertStyle(title: "Ошибка!", message: "Не удалось добавить ответ", preferredStyle: .alert).showAlert(view: self)
                        return
                    }
                    
                    if ans {
                        
                        ApiCaller.instance.setAnswerNotLast(uidTask: self.uidtask, uidAnswer: self.uidAnswer) { (ans, error) in
                            if let error = error {
                                AlertStyle(title: "Ошибка!", message: "Не удалось изменить состояние прошлых ответов", preferredStyle: .alert).showAlert(view: self)
                                return
                            }
                            
                            if ans {
                                ApiCaller.instance.toDo(uidTask: self.uidtask) { (ans, error) in
                                    if let error = error {
                                        AlertStyle(title: "Ошибка!", message: "Не удалось изменить статус задачи", preferredStyle: .alert).showAlert(view: self)
                                        return
                                    }
                                    
                                    if ans {
                                        self.navigationController?.popViewController(animated: true)
                                    } else {
                                        AlertStyle(title: "Ошибка!", message: "Не удалось изменить статус задачи", preferredStyle: .alert).showAlert(view: self)
                                    }
                                }
                            } else {
                                AlertStyle(title: "Ошибка!", message: "Не удалось изменить состояние прошлых ответов", preferredStyle: .alert).showAlert(view: self)
                            }
                        }
                    } else {
                        AlertStyle(title: "Ошибка!", message: "Не удалось изменить состояние прошлых ответов", preferredStyle: .alert).showAlert(view: self)
                    }
                }
            }
        }
    }
    
}
