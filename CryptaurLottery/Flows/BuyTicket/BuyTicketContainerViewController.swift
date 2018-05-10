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
            buyTicketSubview.isHidden = false
            drawArchiveSubview.isHidden = true
            showRulesSubview.isHidden = true
            view.backgroundColor = UIColor.paleLavender
        case 1:
            buyTicketSubview.isHidden = true
            showRulesSubview.isHidden = true
            drawArchiveSubview.isHidden = false
            view.backgroundColor = UIColor.darkTwo
        case 2:
            buyTicketSubview.isHidden = true
            showRulesSubview.isHidden = false
            drawArchiveSubview.isHidden = true
            view.backgroundColor = UIColor.darkTwo

        default:
            fatalError("Unknown segment")
        }
    }
    
    // MARK: - Public property
    var draw: Draw?
    
    // MARK: - Embedde view controllers
    var buyTicketViewController: BuyTicketViewController?
    var drawArchiveViewController: DrawArchiveViewController?
    var showRulesViewController: ShowRulesViewController?
    var drawDetailsViewController: DrawDetailsViewController?
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        configureSubViewControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor.heather
    }
}

// MARK: - Private methods
private extension BuyTicketContainerViewController {
    
    func configureSubviews() {
        view.backgroundColor = UIColor.paleLavender
        configureNavigationItem(showBalance: true, color: UIColor.heather)
        navigationController?.navigationBar.tintColor = UIColor.heather
    }
    
    func configureSubViewControllers() {
        
        buyTicketViewController = buyTicketSubview.subviews
            .first?.parentViewController as? BuyTicketViewController
        buyTicketViewController?.draw = draw
        
        guard let draw = draw,
            let lottery = LotteryID(rawValue: draw.lotteryID) else { return }
        
        drawArchiveViewController = drawArchiveSubview.subviews
            .first?.parentViewController as? DrawArchiveViewController
        drawArchiveViewController?.lottery = lottery
    }
}
