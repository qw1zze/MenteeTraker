import UIKit
import FirebaseAuth

class MainInfoStyle: UIView {
    
    let nameLabel = LabelStyle(text: "", font: .systemFont(ofSize: 24))
    let roleLabel = LabelStyle(text: "", font: .systemFont(ofSize: 20))
    let emailLabel = LabelStyle(text: "", font: .systemFont(ofSize: 20))
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureName()
        configureRole()
        configureEmail()
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
    
    func configureName() {
        self.addSubview(nameLabel)
        
        nameLabel.lineBreakMode = NSLineBreakMode.byTruncatingHead
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 3

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }
    
    func configureRole() {
        self.addSubview(roleLabel)
        
        roleLabel.lineBreakMode = NSLineBreakMode.byTruncatingHead
        roleLabel.textAlignment = .left
        roleLabel.numberOfLines = 1
        
        NSLayoutConstraint.activate([
            roleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            roleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            roleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5)
        ])
    }
    
    func configureEmail() {
        self.addSubview(emailLabel)
        
        emailLabel.lineBreakMode = NSLineBreakMode.byTruncatingHead
        emailLabel.textAlignment = .left
        emailLabel.numberOfLines = 1
        
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: roleLabel.bottomAnchor, constant: 20),
            emailLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            emailLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5)
        ])
    }
    
    func getInfo() {
        ApiCaller.instance.getUserInfo(uid: Auth.auth().currentUser!.uid) { (userInfo) in
            self.nameLabel.text = userInfo.name
            
            if userInfo.role == "trainee" {
                self.roleLabel.text = "Стажер"
            } else if userInfo.role == "mentor" {
                self.roleLabel.text = "Ментор"
            }
            
            self.emailLabel.text = userInfo.email
        }
    }
}
