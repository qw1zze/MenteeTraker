import UIKit
import FirebaseAuth

class CreateNewTaskVC: UIViewController, UITextFieldDelegate {
    
    var uidtask = ""
    var uidAnswer = ""
    var isWarn = false
    var isAdd = false
    var traines: [String] = []
    
    let titleLabel : LabelStyle = {
        let title = LabelStyle(text: "Заголовок", font: .systemFont(ofSize: 20))
        title.textAlignment = .left
        return title
    }()
    let titleField = TextFieldStyle(placeholder: "")
    let traineeLabel : LabelStyle = {
        let title = LabelStyle(text: "Стажер", font: .systemFont(ofSize: 20))
        title.textAlignment = .left
        return title
    }()
    
    let traineeBox = UIPickerView()
    lazy var traineeField: UITextField = {
        var field = TextFieldStyle(placeholder: "")
        field.inputView = traineeBox
        traineeBox.delegate = self
        traineeBox.dataSource = self
        
        field.tintColor = .clear
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTraineeAction))
        toolBar.setItems([doneButton], animated: true)
        
        
        field.inputAccessoryView = toolBar
        return field
    }()
    
    @objc func doneTraineeAction() {
        if traines.count == 1 {
            self.traineeField.text = traines[0]
        }
        view.endEditing(true)
    }
    
    let textViewLabel : LabelStyle = {
        let title = LabelStyle(text: "Описание", font: .systemFont(ofSize: 20))
        title.textAlignment = .left
        return title
    }()
    
    lazy var textView: UITextView = {
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
    
    let deadlineLabel : LabelStyle = {
        let title = LabelStyle(text: "Крайний срок", font: .systemFont(ofSize: 20))
        title.textAlignment = .left
        return title
    }()
    
    let datePicker = UIDatePicker()
    lazy var deadlineField: TextFieldStyle = {
        let field = TextFieldStyle(placeholder: "")
        field.tintColor = .clear
        field.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date.now
        let format = DateFormatter()
        format.dateFormat = "dd.MM.yyyy"
        field.text = format.string(from: Date.now)
        
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        toolBar.setItems([doneButton], animated: true)
        
        field.inputAccessoryView = toolBar
        
        return field
    }()
    
    @objc func doneAction() {
        view.endEditing(true)
    }
    
    @objc func dateChanged() {
        let format = DateFormatter()
        format.dateFormat = "dd.MM.yyyy"
        deadlineField.text = format.string(from: datePicker.date)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        self.navigationItem.title = "Создать задачу"
        
        getTraines()
        
        configuretitleLabel()
        configuretitleField()
        configureTraineeLabel()
        configureTraineeField()
        configuretextViewLabel()
        configureTextView()
        configureDeadLineLabel()
        configureDeadlineField()
        configureConfirmButton()
        HideKeyborad()
        
    }
    
    func getTraines() {
        ApiCaller.instance.getAllTrainees(uidMentor: Auth.auth().currentUser!.uid) { (traines) in
            self.traines = traines
        }
    }
    
    func configuretitleLabel() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
    }
    
    func configuretitleField() {
        view.addSubview(titleField)
        
        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            titleField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureTraineeLabel() {
        view.addSubview(traineeLabel)
        
        NSLayoutConstraint.activate([
            traineeLabel.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 40),
            traineeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            traineeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
    }
    
    func configureTraineeField() {
        view.addSubview(traineeField)

        NSLayoutConstraint.activate([
            traineeField.topAnchor.constraint(equalTo: traineeLabel.bottomAnchor, constant: 5),
            traineeField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            traineeField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            traineeField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configuretextViewLabel() {
        view.addSubview(textViewLabel)
        
        NSLayoutConstraint.activate([
            textViewLabel.topAnchor.constraint(equalTo: traineeField.bottomAnchor, constant: 40),
            textViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            textViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
    }
    
    func configureTextView() {
        
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: textViewLabel.bottomAnchor, constant: 5),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            textView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    func configureDeadLineLabel() {
        view.addSubview(deadlineLabel)
        
        NSLayoutConstraint.activate([
            deadlineLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 50),
            deadlineLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            deadlineLabel.widthAnchor.constraint(equalTo: textView.widthAnchor, multiplier: 0.5)
        ])
    }
    
    func configureDeadlineField() {
        view.addSubview(deadlineField)
        
        NSLayoutConstraint.activate([
            deadlineField.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 40),
            deadlineField.leadingAnchor.constraint(equalTo: deadlineLabel.trailingAnchor, constant: 5),
            deadlineField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            deadlineField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureConfirmButton() {
        view.addSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            confirmButton.topAnchor.constraint(equalTo: deadlineLabel.bottomAnchor, constant: 50),
            confirmButton.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 50),
            confirmButton.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -50),
            confirmButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        confirmButton.addTarget(self, action: #selector(addTask), for: .touchUpInside)
    }
    
    func HideKeyborad() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
    }
    
    @objc func addTask() {
        if titleField.text == "" {
            AlertStyle(title: "Ошибка!", message: "Введите заголовок задачи", preferredStyle: .alert).showAlert(view: self)
            return
        }
        
        if traineeField.text == "" {
            AlertStyle(title: "Ошибка!", message: "Выберете стажера", preferredStyle: .alert).showAlert(view: self)
            return
        }
        
        if textView.text == "" {
            AlertStyle(title: "Ошибка!", message: "Добавьте описание задачи", preferredStyle: .alert).showAlert(view: self)
            return
        }
        
        if deadlineField.text == "" {
            AlertStyle(title: "Ошибка!", message: "Добавьте крайний срок выполнения", preferredStyle: .alert).showAlert(view: self)
            return
        }
        
        ApiCaller.instance.getUserByEmail(email: traineeField.text!.lowercased()) { (uidTrainee, res) in
//            if !res && !self.isWarn {
//                self.isWarn = true
//                print(1)
//                AlertStyle(title: "Ошибка!", message: "Стажера с такой почтой не существует", preferredStyle: .alert).showAlert(view: self)
//            } else 
            if res && !self.isAdd {
                self.isAdd = true
                ApiCaller.instance.addTask(uidTrainee: uidTrainee, taskName: self.titleField.text!, deadline: self.deadlineField.text!) { (ans, error, key) in
                    if let error = error {
                        AlertStyle(title: "Ошибка!", message: "Не удалось создать задачу", preferredStyle: .alert).showAlert(view: self)
                        return
                    }
                    
                    if ans {
                        ApiCaller.instance.addAnswerToTask(uidTask: key, text: self.textView.text!) { (ans, error) in
                            if let error = error {
                                AlertStyle(title: "Ошибка!", message: "Не удалось добавить ответ к задаче", preferredStyle: .alert).showAlert(view: self)
                                return
                            }
                            
                            if ans {
                                self.navigationController?.popViewController(animated: true)
                            } else {
                                AlertStyle(title: "Ошибка!", message: "Не удалось добавить ответ к задаче", preferredStyle: .alert).showAlert(view: self)
                            }
                        }
                    } else {
                        AlertStyle(title: "Ошибка!", message: "Не удалось добавить ответ к задаче", preferredStyle: .alert).showAlert(view: self)
                    }
                }
            }
        }
    }
    
}

extension CreateNewTaskVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return traines.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return traines[row].description
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        traineeField.text = traines.count != 0 ? traines[row].description : ""
    }
}
