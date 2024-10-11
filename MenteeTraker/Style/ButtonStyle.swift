import UIKit

class ButtonStyle : UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(backgroundColor: UIColor, title: String) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: UIControl.State.normal)
        configure()
    }
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.textColor = .white
        titleLabel?.font = .preferredFont(forTextStyle: .headline)
        layer.cornerRadius = 20
    }
}
