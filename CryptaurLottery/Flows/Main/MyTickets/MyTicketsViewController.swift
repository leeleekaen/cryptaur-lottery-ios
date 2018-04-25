import UIKit
import IGListKit
import UInt256

class MyTicketsViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var gradientBackgroundView: GradientBackgroundView!
    @IBOutlet weak var prizePoolAmountLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var getTheWinButton: UIButton!
    
    // MARK: - IBACtion
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            state = .active
        case 1:
            state = .played
        default:
            fatalError("Unknown state")
        }
    }
    
    @IBAction func getTheWin(_ sender: UIButton) {
        print("Get win button tapped")
        viewModel.pickUpWin(for: 0, witjKey: "")
    }
    
    // MARK: - Private properties
    private let viewModel = MyTicketsViewModel()
    lazy private var adapter: ListAdapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)

    var state: State = .active {
        didSet { adapter.reloadData() }
    }
    
    // MARK: - Viewcontroller lidecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        state = .active
        
        gradientBackgroundView.gradientColors = [UIColor.lightblue, UIColor.lighterPurple].map {$0.cgColor}
        gradientBackgroundView.backgroundColor = .clear
        
        configureNavigationItem(showBalance: true)
        
        collectionView.contentInset = .zero
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    // MARK: - Binding
    override func bind() {
        
        viewModel.updateCompletion = { [unowned self] in
            print("active tickets: \(self.viewModel.allActiveTickets.count), played tickets: \(self.viewModel.allPlayedTickets.count)")
            DispatchQueue.main.async { [weak self] in
                self?.adapter.reloadData()
            }
        }
        
        viewModel.winAmount.drive(onNext: { [weak self] in
            self?.prizePoolAmountLabel.text = $0.toString() + " CPT"
        }).disposed(by: disposeBag)
    }
}

// MARK: - ListAdapterDataSource
extension MyTicketsViewController: ListAdapterDataSource {
    
    func listAdapter(_ listAdapter: ListAdapter,
                     sectionControllerFor object: Any) -> ListSectionController {
        
        let sectionController = ListSingleSectionController(nibName: MyTicketsCardCell.nameOfClass, bundle: nil, configureBlock: { [unowned self] (item, cell) in
            
            guard let cell = cell as? MyTicketsCardCell,
                let item = item as? DiffableBox<Ticket> else { return }
            
            cell.configure(state: self.state, ticket: item.value)
            
        }) { (item, collectionContext) -> CGSize in
            let size = collectionContext!.insetContainerSize
            return CGSize(width: size.width, height: 140)
        }
        sectionController.inset = .zero
        return sectionController
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        switch state {
        case .active:
            return viewModel.allActiveTickets.diffable()
        case .played:
            return viewModel.allPlayedTickets.diffable()
        }
    }
}

// MARK: - Embedded type
extension MyTicketsViewController {
    
    enum State {
        case active, played
    }
}

