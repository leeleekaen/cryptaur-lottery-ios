//
//  UIView+FromNib.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 06.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import UIKit

extension UIView {
    private class func instantiateViewFromNib<T: UIView>() -> T {
        return UINib(nibName: nameOfClass, bundle: nil).instantiate(withOwner: nil, options: nil).first as! T
    }
    
    class func loadFromNib() -> Self {
        return instantiateViewFromNib()
    }
}
