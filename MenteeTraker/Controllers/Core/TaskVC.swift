import UIKit
import FirebaseAuth

class TaskVC: UIViewController {

    var uidTask: String = ""
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        
        table.separatorStyle = .none
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(reloadTable), for: .valueChanged)
        table.refreshControl = refresh
        table.register(TaskAnswerTableViewCell.self, forCellReuseIdentifier: "Identifier")
        
        return table
    }()
    
    lazy var taskNameLabel: UILabel = {
        let label = LabelStyle(text: "", font: .systemFont(ofSize: 24))
        label.textAlignment = .left
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = LabelStyle(text: "", font: .systemFont(ofSize: 16))
        label.textAlignment = .left
        return label
    }()
    
    lazy var deadlineLabel: UILabel = {
        let label = LabelStyle(text: "", font: .systemFont(ofSize: 14))
        label.textAlignment = .left
        return label
    }()
    
    var answers = [TaskAnswer]()
    
    private var dataSource = [OptionTaskAnswer]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        
        setupNavigation()
        
        configureTaskNameLabel()
        configureStatusLabel()
        configureDeadlineLabel()
        configureTableView()
    }
    
    func configureTaskNameLabel() {
        self.view.addSubview(taskNameLabel)
        
        NSLayoutConstraint.activate([
            self.taskNameLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15),
            self.taskNameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            self.taskNameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
        ])
    }
    
    func configureStatusLabel() {
        self.view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            self.statusLabel.topAnchor.constraint(equalTo: self.taskNameLabel.bottomAnchor, constant: 5),
            self.statusLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 35),
            self.statusLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
        ])
    }
    
    
    func configureDeadlineLabel() {
        self.view.addSubview(deadlineLabel)
        
        NSLayoutConstraint.activate([
            self.deadlineLabel.topAnchor.constraint(equalTo: self.statusLabel.bottomAnchor, constant: 3),
            self.deadlineLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 35),
            self.deadlineLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
        ])
    }
    
    func configureTableView() {
        self.view.addSubview(self.tableView)
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.deadlineLabel.bottomAnchor, constant: 15),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -15)
        ])
        
        ApiCaller.instance.getAllTaskAnswers(uidTask: uidTask, completion: { (answers) in
            self.answers = answers
            
            self.configureModels()
            
            self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        ApiCaller.instance.getAllTaskAnswers(uidTask: uidTask, completion: { (answers) in
            self.answers = answers
            
            self.configureNameTask()
            self.configureModels()
            
            self.tableView.reloadData()
        })
    }
    
    @objc func reloadTable(_ sender: Any) {
        ApiCaller.instance.getAllTaskAnswers(uidTask: uidTask, completion: { (answers) in
            self.answers = answers
            self.configureNameTask()
            
            self.setupNavigation()
            
            self.configureModels()
            
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        })
    }
    
    private func configureModels() {
        
        var options: [OptionTaskAnswer] = [];
        
        self.dataSource = []
        
        for answer in answers {
            options.append(OptionTaskAnswer(uidAnswer: answer.uidAnswer, text: answer.text, who: answer.who, last: answer.last))
        }
        
        dataSource = options
    }
    
    private func setupNavigation() {
        self.navigationItem.largeTitleDisplayMode = .never
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColorFromRGB(rgbValue: 0x305FBB), NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 27)!]
        appearance.backgroundColor = .systemBackground
        
        ApiCaller.instance.getUserInfo(uid: Auth.auth().currentUser!.uid) { (userInfo) in
            ApiCaller.instance.getTask(uid: self.uidTask) { (task) in
                if userInfo.role == "mentor" && task.status != "ready" {
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Завершить", image: nil, target: self, action: #selector(self.endTask))
                }
            }
        }
        
        configureNameTask()
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    @objc func endTask() {
        ApiCaller.instance.completeTask(uidTask: uidTask) { (ans, error) in
            
            if let error = error {
                AlertStyle(title: "Ошибка!", message: "Не удалось изменить статус на выполненный", preferredStyle: .alert).showAlert(view: self)
                return
            }
            
            if ans {
                self.navigationController?.popViewController(animated: true)
            } else {
                AlertStyle(title: "Ошибка!", message: "Не удалось изменить статус на выполненный", preferredStyle: .alert).showAlert(view: self)
            }
        }
    }
    
    private func configureNameTask() {
        ApiCaller.instance.getTask(uid: uidTask) { (task) in
            self.navigationItem.title = task.name
            self.taskNameLabel.text = task.name
            self.statusLabel.text = TaskShort.printStatus(status: task.status)
            self.deadlineLabel.text = task.deadline
        }
    }
}

extension TaskVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Identifier", for: indexPath) as! TaskAnswerTableViewCell
        cell.uidTask = self.uidTask
        cell.VC = self
        cell.selectionStyle = .none
        
        let model = dataSource[indexPath.row]
        cell.uidAnswer = model.uidAnswer
        
        cell.configureCell(model: model)
        
        return cell
    }
}
