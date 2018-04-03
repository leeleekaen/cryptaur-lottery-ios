//
//  AppDelegate.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 02.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // debug
        //        let service = LoginPasswordService()
        //        let request = LoginPasswordRequestModel(login: "login@mail.ru", password: "mypass", pin: "1234", key: "0xdeadbeef")
        //        service.perform(input: request, success: { (model) in
        //            print(model)
        //        }) { (error) in
        //            print(error)
        //        }
        
        return true
    }
}
