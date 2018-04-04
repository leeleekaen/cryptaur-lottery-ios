//
//  AppDelegate.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 02.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import UIKit
import UInt256

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
        developmentTest()
        
        return true
    }
    
    func developmentTest() {
        let service = GetTicketPriceService()
        let request = GetTicketPriceRequestModel(lotteryID: .lottery5x36)
        service.perform(input: request, success: { (object) in
            print(object)
        }) { (error) in
            print(error)
        }
//        let service = LoginPasswordService()
//        let request = LoginPasswordRequestModel(login: "login@mail.ru", password: "mypass", pin: "1234", key: "0xdeadbeef")
//        service.perform(input: request, success: { (model) in
//            print(model)
//        }) { (error) in
//            print(error)
//        }
    }
    
}
