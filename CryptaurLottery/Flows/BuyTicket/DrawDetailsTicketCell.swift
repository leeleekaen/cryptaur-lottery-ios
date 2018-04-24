//
//  DrawDetailsTicketCell.swift
//  CryptaurLottery
//
//  Created by Tim S on 24.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import UIKit

class DrawDetailsTicketCell: UICollectionViewCell {
    @IBOutlet weak var ticketNameLabel: UILabel!
    @IBOutlet weak var ticketGuessedLabel: UILabel!
    @IBOutlet weak var ticketValueLabel: UILabel!
    
    public func updateWith(item: TicketsTableItem) {
        self.ticketNameLabel.text = item.key
        self.ticketGuessedLabel.text = "NUMBERS GUESSED: " + item.guess
        self.ticketValueLabel.text = item.value
    }
}
