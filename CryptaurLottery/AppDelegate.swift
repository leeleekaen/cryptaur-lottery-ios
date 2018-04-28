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

    lazy var applicationCoordinator: ApplicationCoordinator = ApplicationCoordinator(window: window!)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        applicationCoordinator.startLogin()
        
        developmentTest()
        
        return true
    }
    
    func developmentTest() {
//        GetCurrentLotteriesService().perform(input: (), success: { (response) in
//            print(response)
//        }) { (error) in
//            print(error)
//        }
    }
}

