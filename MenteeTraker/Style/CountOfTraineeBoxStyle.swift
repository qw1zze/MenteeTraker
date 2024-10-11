import UIKit
import FirebaseAuth

class CountOfTraineeBoxStyle: UIView {
    let label = LabelStyle(text: "Количество cтажеров", font: .systemFont(ofSize: 25))
    let countTaskLabel = LabelStyle(text: "", font: .systemFont(ofSize: 45))

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureLabel()
        configureCountTask()
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
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
    
    func configureCountTask() {
        self.addSubview(countTaskLabel)
        
        countTaskLabel.lineBreakMode = NSLineBreakMode.byTruncatingHead
        countTaskLabel.textAlignment = .right
        countTaskLabel.numberOfLines = 1

        NSLayoutConstraint.activate([
            countTaskLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            countTaskLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            countTaskLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1)
        ])
    }
    
    func getInfo() {
        self.countTaskLabel.text = "0"
        ApiCaller.instance.getCountTrainee(uidMentor: Auth.auth().currentUser!.uid) { count in
            self.countTaskLabel.text = String(count)
        }
    }
}
