//
//  DrawDetailsViewController.swift
//  CryptaurLottery
//
//  Created by Tim S on 21.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import UIKit
import IGListKit

class DrawDetailsViewController: BaseViewController {

    @IBOutlet weak var winnersCollectionView: UICollectionView!
    @IBOutlet weak var ticketsCollectionView: UICollectionView!
    @IBOutlet weak var ticketsView: UIView!
    
    lazy var adapter: ListAdapter =  {
        let updater = ListAdapterUpdater()
        let adapter = ListAdapter(updater: updater,
                                  viewController: self,
                                  workingRangeSize: 1)
        adapter.collectionView = winnersCollectionView
        adapter.dataSource = LoteryWinnersDataSource()
        return adapter
    }()

    lazy var adapterTickets: ListAdapter =  {
        let updater = ListAdapterUpdater()
        let adapter = ListAdapter(updater: updater,
                                  viewController: self,
                                  workingRangeSize: 1)
        adapter.collectionView = ticketsCollectionView
        adapter.dataSource = LoteryTicketsDataSource()
        return adapter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        winnersCollectionView.backgroundColor = UIColor.paleLavender
        winnersCollectionView.superview?.backgroundColor = UIColor.paleLavender
        ticketsCollectionView.backgroundColor = UIColor.white
        ticketsView.backgroundColor = UIColor.white
        
        winnersCollectionView.tintColor = UIColor.heather
        ticketsCollectionView.tintColor = UIColor.heather
        
        _ = adapter
        _ = adapterTickets
    }

}

// --- List of Winners ---

class LoteryWinnersDataSource: NSObject, ListAdapterDataSource {
    
    let winners: [String] = ["LOTTERY", "DRAW", "DATE", "WIN NUMBERS", "TICKETS", "COLLECTED","PAID", "TO JACKPOT", "TO RESERVE", "JACKPOT", "RESERVE"]
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var winnerItems: [WinnersTableItem] = [WinnersTableItem]()
        for item in winners {
            let tableItem = WinnersTableItem(key: item, value: "")
            winnerItems.append(tableItem)
        }
        
        return winnerItems
    }
    
    func listAdapter(_ listAdapter: ListAdapter,
                     sectionControllerFor object: Any) -> ListSectionController {
        return WinnersSectionController()
    }
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

class WinnersSectionController: ListSectionController {
    var currentItem: WinnersTableItem? = nil
    
    override func didUpdate(to object: Any) {
        guard let item = object as? WinnersTableItem else {
            return
        }
        currentItem = item
    }
    
    
    override func numberOfItems() -> Int {
        return 1 // One item will be represented by one cell
    }
    
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let nibName = String(describing: DrawDetailsWinnerCell.self)
    
        guard let ctx = collectionContext, let item = currentItem else {
            return UICollectionViewCell()
        }
    
        let cell = ctx.dequeueReusableCell(withNibName: nibName,
                                           bundle: nil,
                                           for: self,
                                           at: index)
        guard let winnerCell = cell as? DrawDetailsWinnerCell else {
            return cell
        }
        winnerCell.updateWith(item: item)
        return winnerCell
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        return CGSize(width: width, height: 23)
    }
}


class WinnersTableItem: ListDiffable {
    var identifier: String = UUID().uuidString
    var key: String = ""
    var value: String = ""
    
    init (key: String, value: String) {
        self.key = key
        self.value = value
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? WinnersTableItem else {
            return false
        }
        return self.identifier == object.identifier
    }
}



//--- List of Tickets ---

class LoteryTicketsDataSource: NSObject, ListAdapterDataSource {
    
    let winners: [String] = ["Test 1", "Test 2"]
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var ticketItems: [TicketsTableItem] = [TicketsTableItem]()
        for item in winners {
            let tableItem = TicketsTableItem(key: item, guess: "1", value: "test CPT")
            ticketItems.append(tableItem)
        }
        
        return ticketItems
    }
    
    func listAdapter(_ listAdapter: ListAdapter,
                     sectionControllerFor object: Any) -> ListSectionController {
        return TicketsSectionController()
    }
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

class TicketsSectionController: ListSectionController {
    var currentItem: TicketsTableItem? = nil
    
    override func didUpdate(to object: Any) {
        guard let item = object as? TicketsTableItem else {
            return
        }
        currentItem = item
    }
    
    
    override func numberOfItems() -> Int {
        return 1 // One item will be represented by one cell
    }
    
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let nibName = String(describing: DrawDetailsTicketCell.self)
        
        guard let ctx = collectionContext, let item = currentItem else {
            return UICollectionViewCell()
        }
        
        let cell = ctx.dequeueReusableCell(withNibName: nibName,
                                           bundle: nil,
                                           for: self,
                                           at: index)
        guard let ticketCell = cell as? DrawDetailsTicketCell else {
            return cell
        }
        ticketCell.updateWith(item: item)
        return ticketCell
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        return CGSize(width: width, height: 58)
    }
}


class TicketsTableItem: ListDiffable {
    var identifier: String = UUID().uuidString
    var key: String = ""
    var guess: String = ""
    var value: String = ""
    
    init (key: String, guess: String, value: String) {
        self.key = key
        self.guess = guess
        self.value = value
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? TicketsTableItem else {
            return false
        }
        return self.identifier == object.identifier
    }
}

