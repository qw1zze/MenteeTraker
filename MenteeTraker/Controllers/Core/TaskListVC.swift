import UIKit
import Firebase

class TaskListVC: UIViewController {

    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(reloadTable), for: .valueChanged)
        table.refreshControl = refresh
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Identifier")
        
        return table
    }()
    
    var tasks = [TaskShort]()
    
    private var dataSource = [SectionTaskList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        
        setupNavigation()
        
        self.view.addSubview(self.tableView)
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        ApiCaller.instance.getUserInfo(uid: Auth.auth().currentUser!.uid) { (userInfo) in
            if userInfo.role == "trainee" {
                ApiCaller.instance.getAllUserTasks(uidUser: Auth.auth().currentUser!.uid) { (tasks) in
                    self.tasks = tasks.reversed()
                    self.tasks.sort(by: {first, second in
                        if first.isReady() && !second.isReady() {
                            return false
                        }
                        return true
                    })
                    
                    self.configureModels()
                    
                    self.tableView.reloadData()
                }
            } else if userInfo.role == "mentor" {
                ApiCaller.instance.getAllUserTasksByMentor(uidMentor: Auth.auth().currentUser!.uid) { (tasks) in
                    self.tasks = tasks.reversed()
                    self.tasks.sort(by: {first, second in
                        if first.isReady() && !second.isReady() {
                            return false
                        }
                        return true
                    })
                    
                    self.configureModels()
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ApiCaller.instance.getUserInfo(uid: Auth.auth().currentUser!.uid) { (userInfo) in
            if userInfo.role == "trainee" {
                ApiCaller.instance.getAllUserTasks(uidUser: Auth.auth().currentUser!.uid) { (tasks) in
                    self.tasks = tasks.reversed()
                    self.tasks.sort(by: {first, second in
                        if first.isReady() && !second.isReady() {
                            return false
                        }
                        return true
                    })
                    
                    self.configureModels()
                    
                    self.tableView.reloadData()
                }
            } else if userInfo.role == "mentor" {
                ApiCaller.instance.getAllUserTasksByMentor(uidMentor: Auth.auth().currentUser!.uid) { (tasks) in
                    self.tasks = tasks.reversed()
                    self.tasks.sort(by: {first, second in
                        if first.isReady() && !second.isReady() {
                            return false
                        }
                        return true
                    })
                    
                    self.configureModels()
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func reloadTable(_ sender: Any) {
        ApiCaller.instance.getUserInfo(uid: Auth.auth().currentUser!.uid) { (userInfo) in
            if userInfo.role == "trainee" {
                ApiCaller.instance.getAllUserTasks(uidUser: Auth.auth().currentUser!.uid) { (tasks) in
                    self.tasks = tasks.reversed()
                    self.tasks.sort(by: {first, second in
                        if first.isReady() && !second.isReady() {
                            return false
                        }
                        return true
                    })
                    
                    self.configureModels()
                    
                    self.tableView.reloadData()
                    self.tableView.refreshControl?.endRefreshing()
                }
            } else if userInfo.role == "mentor" {
                ApiCaller.instance.getAllUserTasksByMentor(uidMentor: Auth.auth().currentUser!.uid) { (tasks) in
                    
                    self.tasks = tasks.reversed()
                    self.tasks.sort(by: {first, second in
                        if first.isReady() && !second.isReady() {
                            return false
                        }
                        return true
                    })
                    
                    self.configureModels()
                    
                    self.tableView.reloadData()
                    self.tableView.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    private func configureModels() {
        
        var options: [OptionTaskList] = [];
        
        self.dataSource = []
        
        for task in tasks {
            options.append(OptionTaskList(name: task.name, status: task.status, deadline: task.deadline, traineeName: task.traineeName, handler: { [weak self] in
                DispatchQueue.main.async {
                    
                    let taskVC = TaskVC()
                    taskVC.uidTask = task.uid
                    self?.navigationController?.pushViewController(taskVC, animated: true)
                }
            }))
        }
        
        dataSource.append(SectionTaskList(title: " ", options: options))
    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColorFromRGB(rgbValue: 0x305FBB), NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 27)!]
        appearance.backgroundColor = .systemBackground
        
        ApiCaller.instance.getUserInfo(uid: Auth.auth().currentUser!.uid) { (userInfo) in
            if userInfo.role == "mentor" {
                let button = UIBarButtonItem(image: UIImage(named: "plus")?.withTintColor(UIColorFromRGB(rgbValue: 0x305FBB)), style: .plain, target: self, action: #selector(self.goToAddTask))
                self.navigationItem.rightBarButtonItem = button
            }
        }
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    @objc func goToAddTask(_ sender: Any) {
        self.navigationController?.pushViewController(CreateNewTaskVC(), animated: true)
    }
}

extension TaskListVC: UITableViewDelegate, UITableViewDataSource {
    
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
    
    private func initTableStyle(_ cell: UITableViewCell, _ model: OptionTaskList) {
        var listConfiguration = cell.defaultContentConfiguration()
        
        listConfiguration.text = model.name
        listConfiguration.textProperties.color = UIColorFromRGB(rgbValue: 0x305FBB)
        
        ApiCaller.instance.getUserInfo(uid: Auth.auth().currentUser!.uid) { (userInfo) in
            if userInfo.role == "mentor" {
                listConfiguration.secondaryText = "Стажер: " + model.traineeName + "\n" + TaskShort.printStatus(status: model.status) + "\n" + model.deadline
            } else if userInfo.role == "trainee" {
                listConfiguration.secondaryText = TaskShort.printStatus(status: model.status) + "\n" + model.deadline
            }
            
            
            cell.contentConfiguration = listConfiguration
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = dataSource[section]
        return model.title
    }
}
