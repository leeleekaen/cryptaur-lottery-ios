//
//  DrawDetailsWinnerCell.swift
//  CryptaurLottery
//
//  Created by Tim S on 22.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import UIKit

class DrawDetailsWinnerCell: UICollectionViewCell {
    
    @IBOutlet weak var WinnerKeyLabel: UILabel!
    @IBOutlet weak var WinnerValueLabel: UILabel!
    
    public func updateWith(item: WinnersTableItem) {
        WinnerKeyLabel.text = item.key;
        WinnerValueLabel.text = item.value;
    }
}
