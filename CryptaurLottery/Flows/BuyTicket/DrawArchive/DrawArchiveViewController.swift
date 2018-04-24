import UIKit
import IGListKit

class DrawArchiveViewController: BaseViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Private properties
    lazy private var adapter: ListAdapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    let lotteries: [Int] = [1, 2, 3, 4, 5, 6, 7]
    
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
    }
}

// MARK: - ListAdapterDataSource
extension DrawArchiveViewController: ListAdapterDataSource {
    
    func listAdapter(_ listAdapter: ListAdapter,
                     sectionControllerFor object: Any) -> ListSectionController {
        
        let sectionController = ListSingleSectionController(nibName: DrawArchiveCardCell.nameOfClass, bundle: nil, configureBlock: { (item, cell) in
            
            guard let cell = cell as? DrawArchiveCardCell,
                let item = item as? DiffableBox<ArchiveDraw> else { return }
            
            cell.configure(with: item.value)
            
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
        return viewModel.draws.diffable()
    }
}

// MARK: - Private methods
private extension DrawArchiveViewController {
    
    func configureSubviews() {
        view.backgroundColor = UIColor.darkTwo
        collectionView.backgroundColor = UIColor.darkTwo
    }
}
