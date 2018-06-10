////
////  BalanceUpdater.swift
////  CryptaurLottery
////
////  Created by Artem Pashkevich on 09.06.2018.
////  Copyright © 2018 Nordavind. All rights reserved.
////
//
//import Foundation
//
//class BalanceUpdater {
//    
//    // MARK: Singletone
//    let sharedInstance: BalanceUpdater = BalanceUpdater()
//    
//    // MARK: Internal properties
//    var tickets: [Ticket] = []
//    
//    // MARK: Private properties
//    private let playerTicketsService = GetPlayerTicketsService()
//
//    private init() {
//        
//    }
//}
//
//extension BalanceUpdater {
//    func update() {
//        // TODO: Send request
//    }
//}
//
//private extension BalanceUpdater {
//    func <#name#>(<#parameters#>) -> <#return type#> {
//        let requestModel = GetPlayerTicketsRequestModel(playerAddress: playerAddress,
//                                                        lotteryID: lottery,
//                                                        offset: offset,
//                                                        count: count)
//        
//        playerTicketsService.perform(input: requestModel,
//                                     success: { [weak self] (responce) in
//                                        
//                                        guard !responce.tickets.isEmpty else {
//                                            self?.isEndOfLottery[lottery] = true
//                                            return
//                                        }
//                                        
//                                        guard let lastPlayedDrawIndex = self?.lastPlayedDraws[lottery] else {
//                                            print("No last played draw for lottery: \(lottery)")
//                                            return
//                                        }
//                                        
//                                        var loadedTickets = [Ticket]()
//                                        responce.tickets.forEach {
//                                            if $0.drawIndex == lastPlayedDrawIndex {
//                                                loadedTickets.append($0)
//                                            }
//                                        }
//                                        
//                                        self?.loadedTickets[lottery]! += loadedTickets
//                                        self?.updateCompletion?()
//        }) { [weak self] (error) in
//            print("Error for lottery \(lottery): \(error)")
//        }
//    }
//}
