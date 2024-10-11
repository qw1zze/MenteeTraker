import UIKit

class LabelStyle : UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(text: String, font: UIFont) {
        super.init(frame: .zero)
        self.text = text
        self.font = font
        configure()
    }
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        textColor = UIColorFromRGB(rgbValue: 0x305FBB)
        adjustsFontSizeToFitWidth = true
        textAlignment = .center
    }
}
