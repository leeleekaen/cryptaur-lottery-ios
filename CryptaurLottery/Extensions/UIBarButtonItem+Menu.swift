//
//  UIBarButtonItem+Menu.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 06.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    class func menu(target: Any, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: target, action: action)
    }
}
