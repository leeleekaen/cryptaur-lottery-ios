import UIKit
import IGListKit

class DrawArchiveViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Private properties
    lazy private var adapter: ListAdapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    let lotteries: [Int] = [1, 2, 3, 4, 5, 6, 7]
    
    // MARK: - Viewcontroller lidecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSubviews()
        
        collectionView.contentInset = .zero
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
}

// MARK: - ListAdapterDataSource
extension DrawArchiveViewController: ListAdapterDataSource {
    
    func listAdapter(_ listAdapter: ListAdapter,
                     sectionControllerFor object: Any) -> ListSectionController {
        
        let sectionController = ListSingleSectionController(nibName: DrawArchiveCardCell.nameOfClass, bundle: nil, configureBlock: { (item, cell) in
            // configure cell
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
        return lotteries.diffable()
    }
}

// MARK: - Private methods
private extension DrawArchiveViewController {
    
    func configureSubviews() {
        view.backgroundColor = UIColor.darkTwo
        collectionView.backgroundColor = UIColor.darkTwo
    }
}
