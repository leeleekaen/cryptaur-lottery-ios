//
//  LotteryListViewController.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 05.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import UIKit
import IGListKit

final class LotteryListViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var gradientBackgroundView: GradientBackgroundView!
    @IBOutlet weak var prizePoolAmountLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

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
            print(self?.viewModel.draws)
            DispatchQueue.main.async { [weak self] in
                self?.adapter.reloadData()
            }
        }
    }
    
    // MARK: - Navigation controller action
    override func didTapMenuBarButtonItem() {
        performSegue(withIdentifier: "ShowMyTickets", sender: nil)
    }
}

// MARK: - ListAdapterDataSource
extension LotteryListViewController: ListAdapterDataSource {
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = ListSingleSectionController(nibName: LotteryCardCell.nameOfClass, bundle: nil, configureBlock: { (item, cell) in
//            guard let cell = cell as? LotteryCardCell,
//                let item = item as? DiffableBox<LotteryID> else {
//                    return
//            }
//            print(111)
            // TODO
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
        let lotteries: [LotteryID] = [.lottery4x20, .lottery5x36, .lottery6x42]
        return lotteries.diffable()
//        return viewModel.draws?.diffable() ?? [ListDiffable]()
    }
}
