import UIKit

class BuyTicketContainerViewController: UIViewController {

    // MARK: - IBoutlet
    @IBOutlet weak var changeSubview: UISegmentedControl! {
        didSet {
            changeSubview.tintColor = UIColor.heather
        }
    }
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
}

// MARK: - Private methods
private extension BuyTicketContainerViewController {
    
    func configureSubviews() {
        view.backgroundColor = UIColor.paleLavender
    }
}
