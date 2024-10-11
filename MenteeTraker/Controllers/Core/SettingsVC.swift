import UIKit
import FirebaseAuth

class SettingsVC: UIViewController {

    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Identifier")
        
        return table
    }()
    
    private var dataSource = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        
        setupNavigation()
        
        configureModels()
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColorFromRGB(rgbValue: 0x305FBB), NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 27)!]
        appearance.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func configureModels() {
        ApiCaller.instance.getUserInfo(uid: Auth.auth().currentUser!.uid) { (userInfo) in
            if userInfo.role == "mentor" {
                self.dataSource.append(Section(title: "Profile", options: [
//                    Option(title: "Изменить почту", handler: { [weak self] in
//                        DispatchQueue.main.async {
//                            let alert = AlertInfoStyle(title: "Введите новую почту", message: nil, preferredStyle: .alert)
//                            
//                            alert.showAlert(view: self!)
//                            
//                            
//                            alert.addAction(UIAlertAction(title: "Изменить", style: .default, handler: { (action) in
//                                
//                                if !Validator.isValidEmail(for: alert.textFields?.first?.text ?? " ") {
//                                    AlertStyle(title: "Некорректная почта!", message: "Попробуйте ввести другую", preferredStyle: .alert).showAlert(view: self!)
//                                    return
//                                }
//                                
//                                AuthManager.instance.insertEmail(with: alert.textFields?.first?.text ?? " ") { error in
//                                    if let error = error {
//                                        AlertStyle(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert).showAlert(view: self!)
//                                    }
//                                }
//                                
//                                ApiCaller.instance.changeEmail(uidUser: Auth.auth().currentUser!.uid, email: alert.textFields?.first?.text ?? " ") { ans, error in
//                                    if ans {
//                                        AlertStyle(title: "Успешно", message: "Почта изменена", preferredStyle: .alert).showAlert(view: self!)
//                                    } else {
//                                        AlertStyle(title: "Ошибка", message: "Возникла ошибка", preferredStyle: .alert).showAlert(view: self!)
//                                    }
//                                }
//                            }))
//                        }
//                    }),
                    Option(title: "Изменить пароль", handler: { [weak self] in
                        DispatchQueue.main.async {
                            let alert = AlertInfoStyle(title: "Введите новый пароль", message: nil, preferredStyle: .alert)
                            
                            alert.showAlert(view: self!)
                            
                            
                            alert.addAction(UIAlertAction(title: "Изменить", style: .default, handler: { (action) in
                            
                            if !Validator.isPasswordValid(for: alert.textFields?.first?.text ?? " ") {
                                AlertStyle(title: "Некорректный пароль!", message: "Попробуйте ввести другой", preferredStyle: .alert).showAlert(view: self!)
                                return
                            } else {
                                AuthManager.instance.insertPassword(with: alert.textFields?.first?.text ?? " ") { error in
                                    if let error = error {
                                        AlertStyle(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert).showAlert(view: self!)
                                    } else {
                                        AlertStyle(title: "Успешно", message: "Пароль изменен", preferredStyle: .alert).showAlert(view: self!)
                                    }
                                }
                            }
                        }))
                    }
                }),
                    Option(title: "Привязать стажера", handler: { [weak self] in
                        DispatchQueue.main.async {
                            let alert = AlertInfoStyle(title: "Введите почту стажера", message: nil, preferredStyle: .alert)
                            
                            alert.showAlert(view: self!)
                            
                            alert.addAction(UIAlertAction(title: "Добавить", style: .default, handler: { (action) in
                                ApiCaller.instance.setMentor(uidMentor: Auth.auth().currentUser!.uid, emailTrainee: alert.textFields?.first?.text ?? "") { ans, error in
                                    if ans {
                                        AlertStyle(title: "Успешно", message: "Стажер добавлен", preferredStyle: .alert).showAlert(view: self!)
                                    }
                                }
                            }))
                        }
                    })
                ]))
                    
                self.dataSource.append(Section(title: "", options: [
                    Option(title: "Выйти", handler: { [weak self] in
                        DispatchQueue.main.async {
                            self?.tapLogout()
                        }
                    })]))
            } else if userInfo.role == "trainee" {
                self.dataSource.append(Section(title: "Profile", options: [
//                    Option(title: "Изменить почту", handler: { [weak self] in
//                        DispatchQueue.main.async {
//                            let alert = AlertInfoStyle(title: "Введите новую почту", message: nil, preferredStyle: .alert)
//                            
//                            alert.showAlert(view: self!)
//                            
//                            
//                            alert.addAction(UIAlertAction(title: "Изменить", style: .default, handler: { (action) in
//                                
//                                if !Validator.isValidEmail(for: alert.textFields?.first?.text ?? " ") {
//                                    AlertStyle(title: "Некорректная почта!", message: "Попробуйте ввести другую", preferredStyle: .alert).showAlert(view: self!)
//                                    return
//                                }
//                                
//                                AuthManager.instance.insertEmail(with: alert.textFields?.first?.text ?? " ") { error in
//                                    if let error = error {
//                                        AlertStyle(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert).showAlert(view: self!)
//                                    }
//                                }
//                                
//                                ApiCaller.instance.changeEmail(uidUser: Auth.auth().currentUser!.uid, email: alert.textFields?.first?.text ?? " ") { ans, error in
//                                    if ans {
//                                        AlertStyle(title: "Успешно", message: "Почта изменена", preferredStyle: .alert).showAlert(view: self!)
//                                    } else {
//                                        AlertStyle(title: "Ошибка", message: "Возникла ошибка", preferredStyle: .alert).showAlert(view: self!)
//                                    }
//                                }
//                            }))
//                        }
//                    }),
                    Option(title: "Изменить пароль", handler: { [weak self] in
                        DispatchQueue.main.async {
                            let alert = AlertInfoStyle(title: "Введите новый пароль", message: nil, preferredStyle: .alert)
                            
                            alert.showAlert(view: self!)
                            
                            
                            alert.addAction(UIAlertAction(title: "Изменить", style: .default, handler: { (action) in
                            
                            if !Validator.isPasswordValid(for: alert.textFields?.first?.text ?? " ") {
                                AlertStyle(title: "Некорректный пароль!", message: "Попробуйте ввести другой", preferredStyle: .alert).showAlert(view: self!)
                                return
                            } else {
                                AuthManager.instance.insertPassword(with: alert.textFields?.first?.text ?? " ") { error in
                                    if let error = error {
                                        AlertStyle(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert).showAlert(view: self!)
                                    } else {
                                        AlertStyle(title: "Успешно", message: "Пароль изменен", preferredStyle: .alert).showAlert(view: self!)
                                    }
                                }
                            }
                        }))
                    }
                })
                ]))
                    
                self.dataSource.append(Section(title: "", options: [
                    Option(title: "Выйти", handler: { [weak self] in
                        DispatchQueue.main.async {
                            self?.tapLogout()
                        }
                    })]))
            }
            self.tableView.reloadData()
        }
    }
    
    @objc private func tapLogout() {
        AuthManager.instance.signOut { [weak self] error in
            guard let self = self else {return}
            
            if let error = error {
                AlertStyle(title: "Ошибка!", message: "Возникла ошибка при выходе", preferredStyle: .alert).showAlert(view: self)
                return
            }
            
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuth()
            }
        }
    }
 }

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = dataSource[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Identifier", for: indexPath)
        
        let model = dataSource[indexPath.section].options[indexPath.row]
        
        initTableStyle(cell, model)
        
        return cell
    }
    
    private func initTableStyle(_ cell: UITableViewCell, _ model: Option) {
        var listConfiguration = cell.defaultContentConfiguration()
        
        listConfiguration.text = model.title
        listConfiguration.textProperties.color = UIColorFromRGB(rgbValue: 0x305FBB)
        
        if model.title == "Sign Out" {
            listConfiguration.textProperties.alignment = .center
        }
        
        cell.contentConfiguration = listConfiguration
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = dataSource[section]
        return model.title
    }
}
