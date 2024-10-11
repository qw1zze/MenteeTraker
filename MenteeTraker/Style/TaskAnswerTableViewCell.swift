import UIKit
import FirebaseAuth

class TaskAnswerTableViewCell: UITableViewCell {

    var VC = UIViewController()
    
    var uidTask = ""
    var uidAnswer = ""
    
    lazy var whoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColorFromRGB(rgbValue: 0x305FBB)
        return label
    }()
    
    let textView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.font = .systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        textView.sizeToFit()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = UIColorFromRGB(rgbValue: 0x305FBB)
        textView.isEditable = false
        textView.dataDetectorTypes = .link
        return textView
    }()
    
    lazy var deadlineLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColorFromRGB(rgbValue: 0x305FBB)
        return label
    }()
    
    var addAnswerButton = ButtonStyle(backgroundColor: UIColorFromRGB(rgbValue: 0x305FBB), title: "Ответить")
    
    lazy var modContentView: UIView = {
        var conView = UIView()
        conView.translatesAutoresizingMaskIntoConstraints = false
        return conView
    }()
    
    func configureModContentView() {
        contentView.addSubview(modContentView)
        
        modContentView.layer.borderColor = CGColorFromRGB(rgbValue: 0x305FBB)
        modContentView.layer.borderWidth = 2
        modContentView.layer.cornerRadius = 20
        
        NSLayoutConstraint.activate([
            modContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            modContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            modContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            modContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ])
        
        configureWhoCreated()
        configureDeadlineLabel()
        configureTextTask()
        
        if true {
            configureAddAnswerButton()
        } else {
            NSLayoutConstraint.activate([
                textView.bottomAnchor.constraint(equalTo: modContentView.bottomAnchor, constant: -15)
            ])
        }
    }
    
    func configureWhoCreated() {
        modContentView.addSubview(whoLabel)
        
        NSLayoutConstraint.activate([
            whoLabel.topAnchor.constraint(equalTo: modContentView.topAnchor, constant: 15),
            whoLabel.leadingAnchor.constraint(equalTo: modContentView.leadingAnchor, constant: 15),
            whoLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
        ])
    }
    
    func configureDeadlineLabel() {
        modContentView.addSubview(deadlineLabel)
        
        NSLayoutConstraint.activate([
            deadlineLabel.topAnchor.constraint(equalTo: modContentView.topAnchor, constant: 15),
            deadlineLabel.leadingAnchor.constraint(equalTo: whoLabel.trailingAnchor, constant: 15),
            deadlineLabel.trailingAnchor.constraint(equalTo: modContentView.trailingAnchor, constant: -15)
        ])
    }
    
    func configureTextTask() {
        modContentView.addSubview(textView)
        
        
        NSLayoutConstraint.activate([
            
            textView.topAnchor.constraint(equalTo: whoLabel.bottomAnchor, constant: 5),
            textView.leadingAnchor.constraint(equalTo: modContentView.leadingAnchor, constant: 15),
            textView.trailingAnchor.constraint(equalTo: modContentView.trailingAnchor, constant: -15),
        ])
    }
    
    func configureAddAnswerButton() {
        modContentView.addSubview(addAnswerButton)
        
        addAnswerButton.addTarget(self, action: #selector(goAddAnswer), for: .touchUpInside)
        addAnswerButton.isHidden = true
        
        NSLayoutConstraint.activate([
            addAnswerButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 5),
            addAnswerButton.leadingAnchor.constraint(equalTo: modContentView.leadingAnchor, constant: 15),
            addAnswerButton.trailingAnchor.constraint(equalTo: modContentView.trailingAnchor, constant: -15),
            addAnswerButton.bottomAnchor.constraint(equalTo: modContentView.bottomAnchor, constant: -15),
            addAnswerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func goAddAnswer() {
        let vc = MakeAnswerVC()
        vc.uidtask = self.uidTask
        vc.uidAnswer = self.uidAnswer
        self.VC.navigationController?.pushViewController(vc, animated: true)
    }
    
    func configureCell(model: OptionTaskAnswer) {
        var backgroundConfigration = self.defaultBackgroundConfiguration()
        backgroundConfigration.backgroundInsets = .init(top: 15, leading: 0, bottom: 15, trailing: 0)
        
        self.backgroundConfiguration = backgroundConfigration
        whoLabel.text = "From: " + model.who
        textView.text = model.text
        textView.sizeToFit()
        
        ApiCaller.instance.getUserInfo(uid: Auth.auth().currentUser!.uid) { (userInfo) in
            ApiCaller.instance.getTask(uid: self.uidTask) { (task) in
                if task.status == "ready" || !model.last || userInfo.role == model.who{
                    self.addAnswerButton.isHidden = true
                } else {
                    self.addAnswerButton.isHidden = false
                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureModContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
