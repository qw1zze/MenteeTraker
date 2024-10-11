import UIKit

class TabVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabs()
        setupStyles()
    }
    
    private func setupTabs() {
        let home = self.createNav(with: "Home", and: UIImage(systemName: "house"), vc: HomeVC())
        let tasks = self.createNav(with: "Tasks", and: UIImage(systemName: "list.clipboard"), vc: TaskListVC())
        let settings = self.createNav(with: "Settings", and: UIImage(systemName: "gearshape"), vc: SettingsVC())
        
        self.setViewControllers([home, tasks, settings], animated: true)
    }
        
    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.viewControllers.first?.navigationItem.title = title
        
        return nav
    }
    
    private func setupStyles() {
        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColorFromRGB(rgbValue: 0x305FBB)
        
        self.tabBar.standardAppearance = tabBarAppearance
        self.tabBar.scrollEdgeAppearance = tabBarAppearance
        self.tabBar.unselectedItemTintColor = .systemBackground
    }
}
