////
////  BalanceUpdater.swift
////  CryptaurLottery
////
////  Created by Artem Pashkevich on 09.06.2018.
////  Copyright © 2018 Nordavind. All rights reserved.
////
//
import Foundation
import Alamofire
import SwiftyJSON

//class BalanceUpdater {
//    
//    // MARK: Internal properties
//    var tickets: [Ticket] = []
//    
//    // MARK: Singletone
//    static let sharedInstance: BalanceUpdater = BalanceUpdater()
//    
//    var alamofireManager: SessionManager?
//    
//    private init() {
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = 10
//        alamofireManager = SessionManager(configuration: configuration)
//    }
//    
//    func deadLineTimeInterval(lotteriId: String, success: @escaping (() -> Void),
//                            failed: @escaping ((String) -> Void)) {
//        
//        Alamofire.request( "https://lottery-1.cryptaur.com/api/getDeadLineTimeInterval/", method: .get, parameters: ["lotteriId": lotteriId]).validate().responseJSON { response in
//            
//            switch response.result {
//                
//            case .success(let value):
//                
//                let json = JSON(value)
//                print(json)
//            
//                success()
//                
//            case .failure(let error):
//                failed(error.localizedDescription)
//            }
//        }
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
