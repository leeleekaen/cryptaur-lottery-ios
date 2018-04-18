//
//  AppDelegate.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 02.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        
        developmentTest()
        
        return true
    }
    
    func developmentTest() {
//        let service = ConnectTokenService()
//        let request = ConnectTokenRequestModel(username: "a.rytikov@nordavind.ru", password: "qwe123", pin: nil)
//        service.perform(input: request, success: { (response) in
//            print(response)
//        }) { (error) in
//            print(error)
//        }
//    }
}

