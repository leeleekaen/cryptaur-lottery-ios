import UIKit

class BuyTicketContainerViewController: BaseViewController {

    // MARK: - IBoutlet
    @IBOutlet weak var buyTicketSubview: UIView!
    @IBOutlet weak var drawArchiveSubview: UIView!
    @IBOutlet weak var showRulesSubview: UIView!
    @IBOutlet weak var drawDetailsSubview: UIView!
    
    @IBOutlet weak var changeSubview: UISegmentedControl! {
        didSet {
            changeSubview.tintColor = UIColor.heather
        }
    }
    
    // MARK: - IBAction
    @IBAction func changeSubviewAction(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            print("Buy ticket")
            buyTicketSubview.isHidden = false
            drawArchiveSubview.isHidden = true
            showRulesSubview.isHidden = true
            view.backgroundColor = UIColor.paleLavender
        case 1:
            print("Draw archive")
            buyTicketSubview.isHidden = true
            showRulesSubview.isHidden = true
            drawArchiveSubview.isHidden = false
            view.backgroundColor = UIColor.darkTwo
        case 2:
            print("Rules")
            buyTicketSubview.isHidden = true
            showRulesSubview.isHidden = false
            drawArchiveSubview.isHidden = true
            view.backgroundColor = UIColor.darkTwo

        default:
            fatalError("Unknown segment")
        }
    }
    
    // MARK: - Public property
    var lottery: LotteryID?
    
    // MARK: - Embedde view controllers
    var buyTicketViewController: BuyTicketViewController?
    var drawArchiveViewController: DrawArchiveViewController?
    var showRulesViewController: ShowRulesViewController?
    var drawDetailsViewController: DrawDetailsViewController?
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        
        buyTicketViewController = buyTicketSubview.subviews
            .first?.parentViewController as? BuyTicketViewController
        
        buyTicketViewController?.lottery = lottery
        
    }
}

// MARK: - Private methods
private extension BuyTicketContainerViewController {
    
    func configureSubviews() {
        view.backgroundColor = UIColor.paleLavender
        configureNavigationItem(showBalance: true, color: UIColor.heather)
    }
}
