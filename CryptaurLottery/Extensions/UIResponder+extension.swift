import UIKit

extension UIResponder {
    var parentViewController: UIViewController? {
        return (self.next as? UIViewController) ?? self.next?.parentViewController
    }
}
