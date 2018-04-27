import UIKit
import UInt256
import KeychainSwift
import IGListKit

final class LotteryListViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var gradientBackgroundView: GradientBackgroundView!
    @IBOutlet weak var prizePoolAmountLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Public properties
    var chooseLotteryCompletion: ((_ lottery: LotteryID) -> ())?
    
    // MARK: - Private properties
    lazy private var adapter: ListAdapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    private let viewModel = LotteryListViewModel()
    
    // MARK: - Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = " "
        gradientBackgroundView.gradientColors = [UIColor.lightblue, UIColor.lighterPurple].map {$0.cgColor}
        gradientBackgroundView.backgroundColor = .clear

        configureNavigationItem(showBalance: true)

        collectionView.contentInset = .zero
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    override func bind() {
        bind(viewModel)
        
        viewModel.updateCompletion = { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.adapter.reloadData()
            }
        }
        
        viewModel.prizePoolAmount.drive(onNext: { [weak self] in
            var amount = $0.toStringWithDelimeters()
            if $0 != UInt256(integerLiteral: 0) { amount.removeLast(5) }
            self?.prizePoolAmountLabel.text = amount + " CPT"
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Navigation controller action
    override func didTapMenuBarButtonItem() {
        performSegue(withIdentifier: "ShowMyTickets", sender: nil)
    }
}

// MARK: - ListAdapterDataSource
extension LotteryListViewController: ListAdapterDataSource {
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = ListSingleSectionController(nibName: LotteryCardCell.nameOfClass, bundle: nil, configureBlock: { [weak self] (item, cell) in

            guard let cell = cell as? LotteryCardCell,
                let item = item as? DiffableBox<Draw> else { return }
            
            cell.configure(draw: item.value)
            cell.buyTicketCompletion = self?.chooseLotteryCompletion
            
        }) { (item, collectionContext) -> CGSize in
            let size = collectionContext!.insetContainerSize
            return CGSize(width: size.width - 56, height: size.height)
        }
        sectionController.inset = .zero
        return sectionController
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return viewModel.draws.diffable()
    }
}
