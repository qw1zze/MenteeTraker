import UIKit

class AlertStyle: UIAlertController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addAction(UIAlertAction(title: "ok", style: .default))
    }
    
    func showAlert(view: UIViewController) {
        view.present(self, animated: true)
    }
}

class AlertInfoStyle: UIAlertController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addTextField(configurationHandler: nil)
        
        self.addAction(UIAlertAction(title: "Отменить", style: .cancel))
        
    }
    
    func showAlert(view: UIViewController) {
        view.present(self, animated: true)
    }
}
