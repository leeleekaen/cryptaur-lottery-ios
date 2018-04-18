import UIKit

class BuyTicketViewController: UIViewController {

    // MARK: - IBAction
    @IBAction func clear(_ sender: UIButton) {
        print("Clear button pressed")
    }
    
    @IBAction func numpadAction(_ sender: UIButton) {
        print("\(sender.titleLabel?.text ?? "") is tapped")
        if sender.currentBackgroundImage == nil {
            sender.setBackgroundImage(#imageLiteral(resourceName: "number-button-background"), for: .normal)
            sender.setTitleColor(.white, for: .normal)
        } else {
            sender.setBackgroundImage(nil, for: .normal)
            sender.setTitleColor(.twilight, for: .normal)
        }
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
