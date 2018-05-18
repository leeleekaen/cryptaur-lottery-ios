//
//  DrawDetailsViewController.swift
//  CryptaurLottery
//
//  Created by Tim S on 21.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import UIKit
import IGListKit
import UInt256
import KeychainSwift

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
        adapter.dataSource = self
        return adapter
    }()

    lazy var adapterTickets: ListAdapter =  {
        let updater = ListAdapterUpdater()
        let adapter = ListAdapter(updater: updater,
                                  viewController: self,
                                  workingRangeSize: 1)
        adapter.collectionView = ticketsCollectionView
        adapter.dataSource = LotteryTicketsDataSource()
        return adapter
    }()
    
    private let getWinTicketsService = GetWinTicketsService()
    private let keychain = KeychainSwift()

    public var winnersTableData: ArchiveDraw? = nil
    public var winnersTableLottery: String? = nil
    public var winnersTicketsLottery: LotteryID? = nil {
        didSet {
            getWinTickets()
        }
    }
    
    private func getWinTickets() {
        
        guard let draw = winnersTableData,
            let lottery = winnersTicketsLottery else {
                print("Some of input data not valid")
                return
        }
        
        let request = GetWinTicketsRequestModel(lotteryID: lottery,
                                                drawIndex: UInt(draw.number),
                                                offset: 0, count: 50)
        getWinTicketsService.perform(input: request,
                                     success: { (responce) in
                                        self.fillTicketsList(tickets: responce.tickets)
                                        print("GetWinTickets responce: \(responce)")
        }) { (error) in
            print("GetWinTickets error: \(error)")
        }
    }
    
    
    let winners: [String] = ["LOTTERY", "DRAW", "DATE", "WIN NUMBERS", "TICKETS", "COLLECTED","PAID", "TO JACKPOT", "TO RESERVE", "JACKPOT", "RESERVE"]
    
    func fillTicketsList(tickets: [WinTicket]) {
        if let ticketDataSource = adapterTickets.dataSource as? LotteryTicketsDataSource {
            print("Start update tickets...")
            ticketDataSource.winnerTickets = tickets
            adapterTickets.reloadData(completion: nil)
        }
    }
    
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

extension DrawDetailsViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var winnerItems: [WinnersTableItem] = [WinnersTableItem]()
        if (winnersTableData != nil && winnersTableLottery != nil) {
            for item in winners {
                var winValue: String = ""
                switch item {
                case "LOTTERY":
                    winValue = winnersTableLottery!
                case "DRAW":
                    if let draw = winnersTableData?.number {
                        winValue = "\(draw)"
                    }
                case "DATE":
                    if let winDate = winnersTableData?.date.description {
                        winValue = winDate
                    }
                case "WIN NUMBERS":
                    winValue = ""
                    if let nums = winnersTableData?.numbers {
                        for num in nums {
                            winValue += "\(num) "
                        }
                    }
                case "TICKETS":
                    if let tickets = winnersTableData?.ticketsBought {
                        winValue = tickets.description
                    }
                case "COLLECTED":
                    if let bought = winnersTableData?.ticketsBought {
                        if let price = winnersTableData?.ticketPrice {
                            let collected = price.unsafeMultiplied(by: UInt256(bought))
                            winValue = collected.description
                        }
                    }
                case "PAID":
                    if let paid = winnersTableData?.payed {
                        winValue = paid.description
                    }
                case "TO JACKPOT":
                    if let toJackpot = winnersTableData?.jackpotAdded {
                        winValue = toJackpot.description
                    }
                case "TO RESERVE":
                    if let toReserve = winnersTableData?.reserveAdded {
                        winValue = toReserve.description
                    }
                case "JACKPOT":
                    if let jackpot = winnersTableData?.jackpot {
                        winValue = jackpot.description
                    }
                case "RESERVE":
                    if let reserve = winnersTableData?.reserve {
                        winValue = reserve.description
                    }
                default:
                    winValue = ""
                }
                
                let tableItem = WinnersTableItem(key: item, value: winValue)
                winnerItems.append(tableItem)
            }
        } else {
            for item in winners {
                print(item)
                let tableItem = WinnersTableItem(key: item, value: "")
                winnerItems.append(tableItem)
            }
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

class LotteryTicketsDataSource: NSObject, ListAdapterDataSource {
    
    public var winnerTickets: [WinTicket]? = nil
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        
        guard let winners = winnerTickets else {
            print("Winners is empty")
            return []
        }
        
        var winCount = 0;
        if winners.count > 3 {
            winCount = 3
        } else {
            winCount = winners.count
        }
        
        var ticketItems: [TicketsTableItem] = [TicketsTableItem]()
        for item in winners.prefix(winCount) {
            var val: String = "0"
            if item.winAmount > 0 {
                val = item.winAmount.toStringWithDelimeters()
            }
            let tableItem = TicketsTableItem(key: item.playerAddress, guess: item.winLevel.description, value: val)
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

