//
//  ShowRulesViewController.swift
//  CryptaurLottery
//
//  Created by Tim S on 20.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import UIKit

class ShowRulesViewController: BaseViewController {

    @IBOutlet weak var rulesTextView: UITextView!

    func configureText() {

        let attributedString = NSMutableAttributedString(string: "Participation\n\nTo participate in the lottery, you must choose any 6 numbers out of 42 in the playing field of the lottery ticket. The number of tickets is unlimited.\n\nTicket price\n\nThe cost of one ticket is determined by the lottery organizer and can be changed. Changes are allowed only after the end of the current drawing lot and before the next one. The ticket is paid by CPT tokens. The cost of GAS for the implementation of a transaction for the ticket purchase is not included in the ticket price and is debited from the participant`s wallet,  i. e. the participant should have enough ETH in the wallet for the ticket purchase. The cost of GAS can vary depending on the workload of the network Ethereum. The purchased tickets cannot be exchanged and returned.\n\nDistribution of funds\nfrom ticket sales\n\nThe funds raised from ticket sale in the current drawing lot are distributed as follows: 90% of the funds form the prize pool of the current draw; 10% of the funds - advertising, marketing, legal expenses, holding rallies.", attributes: [
            .font: UIFont(name: "OpenSans-Regular", size: 16.0)!,
            .foregroundColor: UIColor(white: 1.0, alpha: 1.0),
            .kern: -0.41
            ])

        attributedString.addAttributes([
        .font: UIFont(name: "OpenSans-Regular", size: 20.0)!,
        .foregroundColor: UIColor(red: 163.0 / 255.0, green: 143.0 / 255.0, blue: 187.0 / 255.0, alpha: 1.0)
        ], range: NSRange(location: 0, length: 13))
        attributedString.addAttributes([
        .font: UIFont(name: "OpenSans-Regular", size: 20.0)!,
        .foregroundColor: UIColor(red: 163.0 / 255.0, green: 143.0 / 255.0, blue: 187.0 / 255.0, alpha: 1.0)
        ], range: NSRange(location: 167, length: 12))
        attributedString.addAttributes([
        .font: UIFont(name: "OpenSans-Regular", size: 20.0)!,
        .foregroundColor: UIColor(red: 163.0 / 255.0, green: 143.0 / 255.0, blue: 187.0 / 255.0, alpha: 1.0)
        ], range: NSRange(location: 768, length: 39))
        
        rulesTextView.attributedText = attributedString;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        rulesTextView.backgroundColor = UIColor.darkTwo

        configureText()
    }


}
