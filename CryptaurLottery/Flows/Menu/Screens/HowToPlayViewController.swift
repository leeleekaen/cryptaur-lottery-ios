//
//  HowToPlayViewController.swift
//  CryptaurLottery
//
//  Created by Tim S on 31.05.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import UIKit

class HowToPlayViewController: BaseViewController {

    @IBOutlet weak var howToPlayTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.paleLavender
        howToPlayTextView.backgroundColor = UIColor.paleLavender
        configureText()
    }

    func configureText() {
        let attributedString = NSMutableAttributedString(string: "How to play \n\n Rules of ticket purchase \n\n Choose a lottery, fill it in and buy a ticket. \n\n The number of tickets that can be bought is unlimited. \n\n One hour before the drawing the tickets purchase for this edition is suspended. \n\n To view the statistics on purchased tickets, you need to enter the number of the cryptowallet from which you bought the tickets in section \"My Tickets\". \n\n Time of drawing lots \n\n Drawing lots are held every 154 hours. The remaining time until the next lottery is indicated in the form of a countdown timer in each draw. \n\n Draw \n\n Each draw has its own unique serial number (identifier), according to which it can be found in the \"Statistics\" section. \n\n Lottery broadcasting \n\n Lottery broadcasting (numbers come up) can be viewed by going to the section of the desired lottery during the period when the countdown timer has reset. \n\n How to check the ticket and get a win \n\n After the drawing the system automatically determines winning tickets. The winner of the lottery is responsible for the cost of GAS for getting wins. \n\n The lottery organizer is responsible for the lottery costs. \n\n The history of all drawing lots and payments made can be found in the \"Statistics\" section of each lottery. \n\n You can check your winning tickets in section \"My Tickets\" by entering the number of the cryptowallet from which the lottery tickets were paid.",
                                                  attributes:
            [
                .font: UIFont(name: "OpenSans-Regular", size: 16.0)!,
                .foregroundColor: UIColor.heather,
                .kern: -0.41])
        
        attributedString.addAttributes([
            .font: UIFont(name: "OpenSans-Regular", size: 22.0)!,
            .foregroundColor: UIColor(red: 163.0 / 255.0, green: 143.0 / 255.0, blue: 187.0 / 255.0, alpha: 1.0)
            ], range: NSRange(location: 0, length: 11))

        attributedString.addAttributes([
            .font: UIFont(name: "OpenSans-Regular", size: 20.0)!,
            .foregroundColor: UIColor(red: 163.0 / 255.0, green: 143.0 / 255.0, blue: 187.0 / 255.0, alpha: 1.0)
            ], range: NSRange(location: 15, length: 25))

        attributedString.addAttributes([
            .font: UIFont(name: "OpenSans-Regular", size: 20.0)!,
            .foregroundColor: UIColor(red: 163.0 / 255.0, green: 143.0 / 255.0, blue: 187.0 / 255.0, alpha: 1.0)
            ], range: NSRange(location: 390, length: 21))

        attributedString.addAttributes([
            .font: UIFont(name: "OpenSans-Regular", size: 20.0)!,
            .foregroundColor: UIColor(red: 163.0 / 255.0, green: 143.0 / 255.0, blue: 187.0 / 255.0, alpha: 1.0)
            ], range: NSRange(location: 553, length: 4))
        
        attributedString.addAttributes([
            .font: UIFont(name: "OpenSans-Regular", size: 20.0)!,
            .foregroundColor: UIColor(red: 163.0 / 255.0, green: 143.0 / 255.0, blue: 187.0 / 255.0, alpha: 1.0)
            ], range: NSRange(location: 689, length: 21))

        attributedString.addAttributes([
            .font: UIFont(name: "OpenSans-Regular", size: 20.0)!,
            .foregroundColor: UIColor(red: 163.0 / 255.0, green: 143.0 / 255.0, blue: 187.0 / 255.0, alpha: 1.0)
            ], range: NSRange(location: 870, length: 38))

        howToPlayTextView.attributedText = attributedString;
    }
    
}
