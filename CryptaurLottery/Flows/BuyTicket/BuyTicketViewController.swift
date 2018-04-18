import UIKit

class BuyTicketViewController: UIViewController {

    // MARK: - IBAction

    @IBAction func clear(_ sender: UIButton) {
        print("Clear button pressed")
    }
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
}

// MARK: - Private methods
private extension BuyTicketViewController {
    
    func configureSubviews() {
        view.backgroundColor = UIColor.paleLavender
    }
}
