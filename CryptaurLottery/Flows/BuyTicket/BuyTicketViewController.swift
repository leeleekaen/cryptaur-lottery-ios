import UIKit

class BuyTicketViewController: UIViewController {

    // MARK: - IBoutlets
    @IBOutlet var numbers: [UIButton]!
    
    // MARK: - IBAction
    @IBAction func clear(_ sender: UIButton) {
        numbers.forEach {
            $0.setBackgroundImage(nil, for: .normal)
            $0.setTitleColor(.twilight, for: .normal)
        }
    }
    
    @IBAction func numpadAction(_ sender: UIButton) {
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
