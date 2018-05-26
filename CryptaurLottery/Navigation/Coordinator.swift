//
//  Coordinator.swift
//  CryptaurLottery
//
//  Created by Artem Pashkevich on 26.05.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Foundation

import Foundation
import UIKit



enum State {
    case getLoginAndPassword
    case getFirstPIN
    case getSecondPIN
    case loginWithPIN
    case loginByPasswordFail(ServiceError)
    case loginByPINFail(ServiceError)
    case pincodeNotMatch
    case changePIN
    
}

enum ControllerType {
    
}

class Coordinator {
    func transition (type: TransistionType, vc: UIViewController) {
        switch type {
        case .push(let controller):
            vc.navigationController?.pushViewController(controller, animated: true)
        case .present(let controller):
            vc.present(controller, animated: true, completion: nil)
        case .setRootWindow(let controller):
            UIApplication.shared.keyWindow?.rootViewController = controller
        case .pop:
            vc.navigationController?.popViewController(animated: true)
        case .dismiss:
            vc.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
