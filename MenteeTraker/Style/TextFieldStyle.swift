import UIKit

class TextFieldStyle : UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init (placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        configure()
    }
    
    let padding = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 20
        layer.borderWidth = 2
        layer.borderColor = CGColorFromRGB(rgbValue: 0x305FBB)
        
        textColor = .label
        tintColor = .label
        font = UIFont.preferredFont(forTextStyle: .title3)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 14
        
        autocorrectionType = .no
        
        backgroundColor = .tertiarySystemBackground
        
    }
}
