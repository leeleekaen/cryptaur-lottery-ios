//
//  GradientBackgroundView.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 05.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import UIKit

class GradientBackgroundView: UIView {
    final override class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    private var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    var gradientColors: [CGColor]? {
        get {
            return gradientLayer.colors as? [CGColor]
        }
        set {
            gradientLayer.colors = newValue
            if newValue != nil {
                backgroundColor = nil
            }
        }
    }
}
