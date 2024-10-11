import UIKit
import FirebaseAuth

class CloseDDBoxStyle: UIView {
    let label = LabelStyle(text: "Ближайший deadline", font: .systemFont(ofSize: 25))
    let closeDDLabel = LabelStyle(text: "", font: .systemFont(ofSize: 25))

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureLabel()
        configureCloseDD()
        getInfo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .systemBackground
        self.layer.borderColor = CGColorFromRGB(rgbValue: 0x305FBB)
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 20
    }
    
    func configureLabel() {
        self.addSubview(label)
        
        label.lineBreakMode = NSLineBreakMode.byTruncatingHead
        label.textAlignment = .left
        label.numberOfLines = 2
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            label.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1)
        ])
    }
    
    func configureCloseDD() {
        self.addSubview(closeDDLabel)
        
        closeDDLabel.lineBreakMode = NSLineBreakMode.byTruncatingHead
        closeDDLabel.textAlignment = .right
        closeDDLabel.numberOfLines = 1

        NSLayoutConstraint.activate([
            closeDDLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            closeDDLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            closeDDLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1)
        ])
    }
    
    func getInfo() {
        self.closeDDLabel.text = "Нет задач"
        
        ApiCaller.instance.getAllUserTasks(uidUser: Auth.auth().currentUser!.uid) { (tasks) in
            
            for task in tasks {
                var rev = String(task.deadline.reversed())
                if !task.isReady() && rev < String(self.closeDDLabel.text!.reversed()) {
                    self.closeDDLabel.text = task.deadline
                    return
                }
            }
        }
    }
}
