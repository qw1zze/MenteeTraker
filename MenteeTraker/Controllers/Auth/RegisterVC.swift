import UIKit

class RegisterVC: UIViewController, UITextFieldDelegate {
    
    let logoLabel = LabelStyle(text: "MenteeTraker", font: .systemFont(ofSize: 50))
    let nameField = TextFieldStyle(placeholder: "ФИО")
    let emailField = TextFieldStyle(placeholder: "Email")
    let passwordField = TextFieldStyle(placeholder: "Password")
    let confirmButton = ButtonStyle(backgroundColor: UIColorFromRGB(rgbValue: 0x305FBB), title: "Зарегестрироваться")
    let registerLabel = LabelStyle(text: "Нет аккаунта?", font: .systemFont(ofSize:15))
    let registerButton = ButtonStyle(backgroundColor: .clear, title: "Войти")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureLogoField()
        configureNameField()
        configureEmailField()
        configurePasswordField()
        configureConfirmButton()
        configureRegisterField()
        configureRegisterButton()
        hideKeyborad()
        setupBackColor()
    }
    
    func configureLogoField() {
        
        view.addSubview(logoLabel)
        
        NSLayoutConstraint.activate([
            logoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            logoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            logoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
    }
    
    func configureNameField() {
        
        view.addSubview(nameField)
        
        nameField.delegate = self
        
        NSLayoutConstraint.activate([
            nameField.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 80),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            nameField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureEmailField() {
        
        view.addSubview(emailField)
        
        emailField.delegate = self
        
        NSLayoutConstraint.activate([
            emailField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 30),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            emailField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configurePasswordField() {
        
        view.addSubview(passwordField)
        
        passwordField.delegate = self
        
        NSLayoutConstraint.activate([
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 30),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            passwordField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        addSecureButton()
    }
    
    func configureConfirmButton() {
        view.addSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            confirmButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            confirmButton.leadingAnchor.constraint(equalTo: passwordField.leadingAnchor, constant: 50),
            confirmButton.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor, constant: -50),
            confirmButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        confirmButton.addTarget(self, action: #selector(goSignUp), for: .touchUpInside)
    }
    
    func configureRegisterField() {
        view.addSubview(registerLabel)
        
        NSLayoutConstraint.activate([
            registerLabel.topAnchor.constraint(equalTo: confirmButton.bottomAnchor, constant: 40),
            registerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        registerLabel.textColor = .systemGray2
    }

    func configureRegisterButton() {
        view.addSubview(registerButton)
        
        NSLayoutConstraint.activate([
            registerButton.topAnchor.constraint(equalTo: registerLabel.bottomAnchor),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
        
        registerButton.setTitleColor(UIColorFromRGB(rgbValue: 0x305FBB), for: .normal)
        
        registerButton.addTarget(self, action: #selector(goLogin), for: .touchUpInside)
    }
    
    func hideKeyborad() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
    }
    
    @objc func goSignUp() {
        let registerUserRequest = RegisterUserRequest(name: self.nameField.text ?? "", email: self.emailField.text ?? "", password: self.passwordField.text ?? "")
        
        if !Validator.isValidName(for: registerUserRequest.name) {
            AlertStyle(title: "Неверное ФИО!", message: "Должны использоваться только буквы", preferredStyle: .alert).showAlert(view: self)
            return
        }
        
        if !Validator.isValidEmail(for: registerUserRequest.email) {
            AlertStyle(title: "Некорректная почта!", message: "Попробуйте ввести другую", preferredStyle: .alert).showAlert(view: self)
            return
        }
        
        if !Validator.isPasswordValid(for: registerUserRequest.password) {
            AlertStyle(title: "Некорректный формат пароля!", message: "Пароль должен быть от 9 символов, содержать цифры, заглавные и строчные буквы, спецсимволы", preferredStyle: .alert).showAlert(view: self)
            return
        }
        
        AuthManager.instance.registerUser(with: registerUserRequest) { [weak self] wasRegistred, error in
            guard let self = self else {return}
            
            if let error = error {
                AlertStyle(title: "Ошибка!", message: "Пользователь с данной почтой уже существует", preferredStyle: .alert).showAlert(view: self)
                return
            }
            
            if wasRegistred {
                if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.checkAuth()
                }
            } else {
                AlertStyle(title: "Ошибка!", message: "Возникла неизвестная ошибка", preferredStyle: .alert).showAlert(view: self)
            }
        }
    }
    
    @objc func goLogin() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func addSecureButton() {
        let rightButton  = UIButton(type: .custom)
        rightButton.setImage(UIImage(named: "eye.fill")?.withTintColor(.gray) , for: .normal)
        rightButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        rightButton.addTarget(self, action: #selector(toggleShowHide), for: .touchUpInside)
        
        passwordField.rightViewMode = .always
        passwordField.rightView = rightButton
        passwordField.isSecureTextEntry = true
    }
    
    @objc func toggleShowHide(button: UIButton) {
        passwordField.isSecureTextEntry = !passwordField.isSecureTextEntry
        if passwordField.isSecureTextEntry {
            button.setImage(UIImage(named: "eye.fill")?.withTintColor(.gray) , for: .normal)
        } else {
            button.setImage(UIImage(named: "eye.slash.fill")?.withTintColor(.gray) , for: .normal)
        }
    }
    
    func setupBackColor() {
        self.navigationController?.navigationBar.tintColor = UIColorFromRGB(rgbValue: 0x305FBB)
    }
}
