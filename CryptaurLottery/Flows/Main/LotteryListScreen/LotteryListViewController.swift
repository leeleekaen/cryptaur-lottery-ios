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
    var draw: Draw?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .white
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
}

// MARK: - ListAdapterDataSource
extension LotteryListViewController: ListAdapterDataSource {
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = ListSingleSectionController(nibName: LotteryCardCell.nameOfClass, bundle: nil, configureBlock: { [weak self] (item, cell) in

            guard let cell = cell as? LotteryCardCell,
                let item = item as? DiffableBox<Draw> else { return }
            
            cell.delegate = self
            cell.configure(draw: item.value)
            self?.draw = item.value
            
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

//MARK: LotteryCardCellDelegate
extension LotteryListViewController: LotteryCardCellDelegate {
    func lotteryCardCellAction(cell: LotteryCardCell, buttonPressed: UIButton) {
        let controller = BuyTicketContainerViewController.controllerFromStoryboard(StoryboardType.buyTicketStory.name)
        controller.draw = draw
        UIApplication.sharedCoordinator.transition(type: .push(controller: controller))
    }
}

