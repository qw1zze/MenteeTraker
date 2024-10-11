import UIKit
import FirebaseAuth

class MentorBoxStyle: UIView {
    let label = LabelStyle(text: "Ментор", font: .systemFont(ofSize: 30))
    let mentorLabel = LabelStyle(text: "", font: .systemFont(ofSize: 20))

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureLabel()
        configureMentorLabel()
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
    
    func configureMentorLabel() {
        self.addSubview(mentorLabel)
        
        mentorLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        mentorLabel.textAlignment = .right
        mentorLabel.numberOfLines = 3
        mentorLabel.adjustsFontSizeToFitWidth = true

        NSLayoutConstraint.activate([
            mentorLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            mentorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            mentorLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8)
        ])
    }
    
    func getInfo() {
        ApiCaller.instance.getUserInfo(uid: Auth.auth().currentUser!.uid) { (user) in
            ApiCaller.instance.getUserInfo(uid: user.mentor) { (mentor) in
                self.mentorLabel.text = mentor.name == "" ? "Не назначен": mentor.name.replacingOccurrences(of: " ", with: "\n")
            }
        }
    }
}
