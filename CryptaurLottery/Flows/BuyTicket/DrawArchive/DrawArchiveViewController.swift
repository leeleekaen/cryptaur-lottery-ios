import UIKit
import IGListKit

class DrawArchiveViewController: BaseViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Public properties
    var lottery: LotteryID? {
        didSet {
            viewModel.lottery = lottery
        }
    }
    
    // MARK: - Private properties
    lazy private var adapter: ListAdapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    
    // MARK: - Dependency
    let viewModel = DrawArchiveViewModel()
    
    // MARK: - Viewcontroller lidecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSubviews()
        
        collectionView.contentInset = .zero
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    override func bind() {
        
        viewModel.updateCompletion = {
            DispatchQueue.main.async { [weak self] in
                self?.adapter.reloadData()
            }
        }
        
        viewModel.isLoading.drive(onNext: { [weak self] in
            self?.activityIndicator.isHidden = !$0
        }).disposed(by: disposeBag)
    }
}

// MARK: - ListAdapterDataSource
extension DrawArchiveViewController: ListAdapterDataSource {
    
    func listAdapter(_ listAdapter: ListAdapter,
                     sectionControllerFor object: Any) -> ListSectionController {
        
        let sectionController = ListSingleSectionController(nibName: DrawArchiveCardCell.nameOfClass, bundle: nil, configureBlock: { [weak self] (item, cell) in
            
            guard let cell = cell as? DrawArchiveCardCell,
                let item = item as? DiffableBox<ArchiveDraw> else { return }
            
            cell.configure(with: item.value)
            
            if let lastDraw = self?.viewModel.draws.last, item.value == lastDraw {
                self?.viewModel.getNextDraws()
            }
            
        }) { (item, collectionContext) -> CGSize in
            let size = collectionContext!.insetContainerSize
            return CGSize(width: size.width, height: 140)
        }
        sectionController.inset = .zero
        sectionController.selectionDelegate = self
        return sectionController
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return viewModel.draws.diffable()
    }
}

extension DrawArchiveViewController: ListSingleSectionControllerDelegate {
    
    func didSelect(_ sectionController: ListSingleSectionController, with object: Any) {
        
        guard let object = object as? DiffableBox<ArchiveDraw> else { return }
        
        let draw = object.value
    }
}

// MARK: - Private methods
private extension DrawArchiveViewController {
    
    func configureSubviews() {
        view.backgroundColor = UIColor.darkTwo
        collectionView.backgroundColor = UIColor.darkTwo
    }
}
