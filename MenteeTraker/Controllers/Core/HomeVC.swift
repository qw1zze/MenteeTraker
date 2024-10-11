import UIKit
import FirebaseAuth

class HomeVC: UIViewController {

    lazy var mainInfoBox = MainInfoStyle(frame: .zero)
    lazy var countTaskBox = CountTaskBoxStyle(frame: .zero)
    lazy var closeDDBox = CloseDDBoxStyle(frame: .zero)
    lazy var mentorBox = MentorBoxStyle(frame: .zero)
    lazy var missedDDBox = MissedDDBoxStyle(frame: .zero)
    lazy var countOfTraineeBox = CountOfTraineeBoxStyle(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .secondarySystemBackground
        
        setupNavigation()
        
        configureMainInfoBox()
        
        ApiCaller.instance.getUserInfo(uid: Auth.auth().currentUser!.uid) { (userInfo) in
            if userInfo.role == "trainee" {
                self.configureCountTaskBox()
                self.configureCloseDDBox()
                self.configureMentorBox()
                self.configureMissedDDBox()
            } else if userInfo.role == "mentor" {
                self.configureCountOfTraineeBox()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ApiCaller.instance.getUserInfo(uid: Auth.auth().currentUser!.uid) { (userInfo) in
            if userInfo.role == "trainee" {
                self.countTaskBox.getInfo()
                self.closeDDBox.getInfo()
                self.mentorBox.getInfo()
                self.missedDDBox.getInfo()
            } else if userInfo.role == "mentor" {
                self.countOfTraineeBox.getInfo()
            }
        }
    }
    
    private func configureMainInfoBox() {
        
        view.addSubview(mainInfoBox)
        
        NSLayoutConstraint.activate([
            mainInfoBox.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            mainInfoBox.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            mainInfoBox.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            mainInfoBox.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    private func configureCountTaskBox() {
        view.addSubview(countTaskBox)
        
        NSLayoutConstraint.activate([
            countTaskBox.topAnchor.constraint(equalTo: mainInfoBox.bottomAnchor, constant: 30),
            countTaskBox.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            countTaskBox.widthAnchor.constraint(equalTo: mainInfoBox.widthAnchor, multiplier: 0.45),
            countTaskBox.heightAnchor.constraint(equalTo: mainInfoBox.widthAnchor, multiplier: 0.45)
        ])
    }
    
    private func configureCloseDDBox() {
        view.addSubview(closeDDBox)
        
        NSLayoutConstraint.activate([
            closeDDBox.topAnchor.constraint(equalTo: mainInfoBox.bottomAnchor, constant: 30),
            closeDDBox.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            closeDDBox.widthAnchor.constraint(equalTo: mainInfoBox.widthAnchor, multiplier: 0.45),
            closeDDBox.heightAnchor.constraint(equalTo: mainInfoBox.widthAnchor, multiplier: 0.45)
        ])
    }
    
    private func configureMentorBox() {
        view.addSubview(mentorBox)
        
        NSLayoutConstraint.activate([
            mentorBox.topAnchor.constraint(equalTo: countTaskBox.bottomAnchor, constant: 30),
            mentorBox.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            mentorBox.widthAnchor.constraint(equalTo: mainInfoBox.widthAnchor, multiplier: 0.45),
            mentorBox.heightAnchor.constraint(equalTo: mainInfoBox.widthAnchor, multiplier: 0.45)
        ])
    }
    
    private func configureMissedDDBox() {
        view.addSubview(missedDDBox)
        
        NSLayoutConstraint.activate([
            missedDDBox.topAnchor.constraint(equalTo: closeDDBox.bottomAnchor, constant: 30),
            missedDDBox.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            missedDDBox.widthAnchor.constraint(equalTo: mainInfoBox.widthAnchor, multiplier: 0.45),
            missedDDBox.heightAnchor.constraint(equalTo: mainInfoBox.widthAnchor, multiplier: 0.45)
        ])
    }
    
    private func configureCountOfTraineeBox() {
        
        view.addSubview(countOfTraineeBox)
        
        NSLayoutConstraint.activate([
            countOfTraineeBox.topAnchor.constraint(equalTo: mainInfoBox.bottomAnchor, constant: 30),
            countOfTraineeBox.leadingAnchor.constraint(equalTo: mainInfoBox.leadingAnchor),
            countOfTraineeBox.trailingAnchor.constraint(equalTo: mainInfoBox.trailingAnchor),
            countOfTraineeBox.heightAnchor.constraint(equalTo: mainInfoBox.widthAnchor, multiplier: 0.45)
        ])
    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        let bounds = self.navigationController!.navigationBar.bounds
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width:bounds.width, height: bounds.height + 200)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColorFromRGB(rgbValue: 0x305FBB), NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 27)!]
        appearance.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

