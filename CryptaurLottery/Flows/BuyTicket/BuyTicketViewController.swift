import UIKit

class BuyTicketViewController: UIViewController {

    // MARK: - IBoutlets
    @IBOutlet var numbers: [UIButton]!
    @IBOutlet weak var selectNumberLabel: UILabel!
    
    // MARK: - IBAction
    @IBAction func clear(_ sender: UIButton) {
        selectedNumbers = []
        numbers.forEach {
            $0.setBackgroundImage(nil, for: .normal)
            $0.setTitleColor(.twilight, for: .normal)
        }
    }
    
    @IBAction func numpadAction(_ sender: UIButton) {
        
        guard let title = sender.titleLabel?.text,
            let number = Int(title),
            let lottery = lottery else { return }
        
        if sender.currentBackgroundImage == nil {
            if lottery.toPick > selectedNumbers.count {
                selectedNumbers.append(number)
                sender.setBackgroundImage(#imageLiteral(resourceName: "number-button-background"), for: .normal)
                sender.setTitleColor(.white, for: .normal)
            }
            
        } else {
            if let index = selectedNumbers.index(of: number) {
                sender.setBackgroundImage(nil, for: .normal)
                sender.setTitleColor(.twilight, for: .normal)
                selectedNumbers.remove(at: index)
            }
        }
    }
    
    @IBAction func buyAction(_ sender: UIButton) {
        print("Buy tapped")
    }
    
    // MARK: - Dependency
    var lottery: LotteryID? = .lottery5x36
    
    // MARK: - Private properties
    var selectedNumbers = [Int]()
    
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
        
        guard let lottery = lottery else {
            return
        }
        
        numbers.forEach {
            let number = Int(($0.titleLabel?.text)!)!
            if number > lottery.total {
                $0.isEnabled = false
                $0.setTitleColor(UIColor.paleLavender, for: .normal)
            }
        }
        
        selectNumberLabel.text = "SELECT \(lottery.toPick) NUMBERS"
    }
}
