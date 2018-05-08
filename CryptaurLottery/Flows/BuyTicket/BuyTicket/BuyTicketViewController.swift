import UIKit

class BuyTicketViewController: BaseViewController {

    // MARK: - IBoutlets
    @IBOutlet var numpad: [UIButton]!
    @IBOutlet weak var selectNumberLabel: UILabel!
    @IBOutlet weak var buyTicketButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func clear(_ sender: UIButton) {
        selectedNumbers = []
        numpad.forEach {
            $0.setBackgroundImage(nil, for: .normal)
            $0.setTitleColor(.twilight, for: .normal)
        }
    }
    
    @IBAction func numpadAction(_ sender: UIButton) {
        
        guard let title = sender.titleLabel?.text,
            let number = Int(title),
            let draw = draw,
            let lottery = LotteryID(rawValue: draw.lotteryID) else {return }
        
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
                
        guard let draw = draw,
            let lottery = LotteryID(rawValue: draw.lotteryID) else { return }
        
        if selectedNumbers.count == lottery.toPick {
            viewModel.buyTicket(numbers: selectedNumbers)
        }
    }
    
    // MARK: - Dependency
    let viewModel = BuyTicketViewModel()
    
    // MARK: - Public properties
    var draw: Draw? {
        didSet {
            viewModel.draw = draw
            configureSubviews()
        }
    }
    
    // MARK: - Private properties
    private var selectedNumbers = [Int]()
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Binding
    override func bind() {
        bind(viewModel)
        
        viewModel.ticketPrice.drive(onNext: { [weak self] in
            self?.buyTicketButton.setTitle("Buy for \($0.toString())", for: .normal)
        }).disposed(by: disposeBag)
    }
}

// MARK: - Private methods
private extension BuyTicketViewController {
    
    func configureSubviews() {
        
        guard let draw = draw,
            let lottery = LotteryID(rawValue: draw.lotteryID) else {return }
        
        view.backgroundColor = UIColor.paleLavender
        
        numpad.forEach {
            let number = Int(($0.titleLabel?.text)!)!
            if number > lottery.total {
                $0.isEnabled = false
                $0.setTitleColor(UIColor.paleLavender, for: .normal)
            }
        }
        
        selectNumberLabel.text = "SELECT \(lottery.toPick) NUMBERS"
    }
}
