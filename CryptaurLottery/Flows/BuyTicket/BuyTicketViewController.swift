import UIKit

class BuyTicketViewController: UIViewController {

    // MARK: - IBAction

    @IBAction func clear(_ sender: UIButton) {
        print("Clear button pressed")
    }
    
    @IBAction func numpadAction(_ sender: UIButton) {
        print("\(sender.titleLabel?.text ?? "") is tapped")
    }
    
    @IBAction func buyAction(_ sender: UIButton) {
        print("Buy tapped")
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
