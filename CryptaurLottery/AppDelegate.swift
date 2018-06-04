import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    lazy var applicationCoordinator: ApplicationCoordinator = ApplicationCoordinator(window: window!)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        applicationCoordinator.start()
        
        return true
    }
}

// MARK: App Coordinator
extension UIApplication {
    static var sharedCoordinator: ApplicationCoordinator {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.applicationCoordinator
    }
}

