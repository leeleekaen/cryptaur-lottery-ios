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
    @IBOutlet weak var topConstraintSegmentedControl: NSLayoutConstraint!
    
    // MARK: - Private properties
    var refresher:UIRefreshControl!
    
    private let viewModel = MyTicketsViewModel()
    lazy private var adapter: ListAdapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    
    var state: State = .active {
        didSet { adapter.reloadData() }
    }
    
    // MARK: - Viewcontroller lidecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    func configurePullToRefresh() {
        collectionView.alwaysBounceVertical = true
        refresher = UIRefreshControl()
        refresher.tintColor = .white
        refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.addSubview(refresher)
    }
    
    @objc private func refresh() {
        viewModel.reset()
        viewModel.getNext()
        refresher.endRefreshing()
    }
    
    // MARK: - Binding
    override func bind() {
        bind(viewModel)
        
        viewModel.updateCompletion = { [unowned self] in
            DispatchQueue.main.async { [weak self] in
                self?.adapter.reloadData()
            }
        }
        
        viewModel.winAmount.drive(onNext: { [weak self] in
            self?.prizePoolAmountLabel.text = $0.toStringWithDelimeters() + " CPT"
        }).disposed(by: disposeBag)
    }
}

//MARk: Setup View
extension MyTicketsViewController {
    func setupView() {
        gradientBackgroundView.gradientColors = [UIColor.lightblue, UIColor.lighterPurple].map {$0.cgColor}
        gradientBackgroundView.backgroundColor = .clear
        
        configureNavigationItem(showBalance: true)
        configurePullToRefresh()
        
        collectionView.contentInset = .zero
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
        safeAreaConstraints()
    }
    
    func safeAreaConstraints () {
        if #available(iOS 11, *) {
            // safe area constraints already set
        } else {
            guard let navigation = self.navigationController else {
                return
            }
            topConstraintSegmentedControl.constant += navigation.navigationBar.frame.height*1.5
        }
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
            
            guard self.viewModel.loadingCount == 0, self.state == .played else { return }
            
            if let lastTicket = self.viewModel.allPlayedTickets.last, item.value == lastTicket {
                self.viewModel.getNext()
            }
            
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

//MARK: - IBACtion
extension MyTicketsViewController {
    // MARK:
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
        viewModel.pickUpWin()
    }
}

// MARK: - Embedded type
extension MyTicketsViewController {
    
    enum State {
        case active, played
    }
}

