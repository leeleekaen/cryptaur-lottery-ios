import UIKit

class BuyTicketViewController: BaseViewController {

    // MARK: - IBoutlets
    @IBOutlet var numpad: [UIButton]!
    @IBOutlet weak var selectNumberLabel: UILabel!
    @IBOutlet weak var availableLabe: UILabel!
    
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
            let number = Int(title) else { return }
        
        if sender.currentBackgroundImage == nil {
            if viewModel.lottery.toPick > selectedNumbers.count {
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
        if selectedNumbers.count == viewModel.lottery.toPick {
            viewModel.buyTicket(numbers: selectedNumbers)
        }
    }
    
    // MARK: - Dependency
    let viewModel = BuyTicketViewModel()
    
    // MARK: - Private properties
    var selectedNumbers = [Int]()
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        bind()
    }
    
    // MARK: - Binding
    override func bind() {
        
        viewModel.balance.drive(onNext: { [weak self] in
            self?.availableLabe.text = "Available \($0.toString()) CPT"
        }).disposed(by: disposeBag)
    }
}

// MARK: - Private methods
private extension BuyTicketViewController {
    
    func configureSubviews() {
        
        view.backgroundColor = UIColor.paleLavender
        
        numpad.forEach {
            let number = Int(($0.titleLabel?.text)!)!
            if number > viewModel.lottery.total {
                $0.isEnabled = false
                $0.setTitleColor(UIColor.paleLavender, for: .normal)
            }
        }
        
        selectNumberLabel.text = "SELECT \(viewModel.lottery.toPick) NUMBERS"
    }
}
