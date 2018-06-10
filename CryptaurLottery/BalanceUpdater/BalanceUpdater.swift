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

class BalanceUpdater {
    
    let sharedInstance: BalanceUpdater = BalanceUpdater()
    
    // MARK: Internal properties
    var tickets: [Ticket] = []
    
    
    // MARK: Singletone
    static let instance = BalanceUpdater()
    
    var alamofireManager: SessionManager?
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        alamofireManager = SessionManager(configuration: configuration)
    }
    
    
    
    func loadAllCityBusStop(lotteriId: String, success: @escaping (([Stop]) -> Void),
                            failed: @escaping ((String) -> Void)) {
        
        Alamofire.request( "http://192.168.4.199:24892/api/getDeadLineTimeInterval/{lotteriId}", method: .get, parameters: ["lotteriId": lotteriId]).validate().responseJSON { response in
            
            switch response.result {
                
            case .success(let value):
                
                let json = JSON(value)
                print(json)
                
                var busStop: [Stop] = []
                
                for json in json.arrayValue {
                    
                    let busStopModel = Stop(json: json)
                    busStop.append(busStopModel)
                }
                
                success(busStop)
                
            case .failure(let error):
                failed(error.localizedDescription)
            }
        }
        
}
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
