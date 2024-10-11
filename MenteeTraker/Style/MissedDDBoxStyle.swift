import UIKit
import FirebaseAuth

class MissedDDBoxStyle: UIView {
    let label = LabelStyle(text: "Количество пропущенных задач", font: .systemFont(ofSize: 30))
    let missedDDLabel = LabelStyle(text: "", font: .systemFont(ofSize: 45))

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureLabel()
        configureMissedDDLabel()
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
        label.numberOfLines = 3
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            label.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8)
        ])
    }
    
    func configureMissedDDLabel() {
        self.addSubview(missedDDLabel)
        
        missedDDLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        missedDDLabel.textAlignment = .right
        missedDDLabel.numberOfLines = 1
        missedDDLabel.adjustsFontSizeToFitWidth = true

        NSLayoutConstraint.activate([
            missedDDLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            missedDDLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            missedDDLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8)
        ])
    }
    
    func getInfo() {
        self.missedDDLabel.text = "0"
        
        ApiCaller.instance.getAllUserTasks(uidUser: Auth.auth().currentUser!.uid) { (tasks) in
            
            var time = NSDate()
            var formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            var actual = String(formatter.string(from: time as Date))
            var count = 0

            for task in tasks {
                var rev = String(task.deadline.reversed())
                
                if !task.isReady() && rev < String(actual.reversed()) {
                    count += 1
                }
            }
            self.missedDDLabel.text = String(count)
        }
    }
}
