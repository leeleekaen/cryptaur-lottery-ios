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
    
    @IBAction func closeClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.paleLavender
        howToPlayTextView.backgroundColor = UIColor.paleLavender
        configureText()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        howToPlayTextView.setContentOffset(CGPoint.zero, animated: false)
    }
}

//MARK: Setup View
private extension HowToPlayViewController {
    func configureText() {
        let attributedString = NSMutableAttributedString(string: "How to play \n\nRules of ticket purchase \n\nChoose a lottery, fill it in and buy a ticket. \n\nThe number of tickets that can be bought is unlimited. \n\nOne hour before the drawing the tickets purchase for this edition is suspended. \n\nTo view the statistics on purchased tickets, you need to enter the number of the cryptowallet from which you bought the tickets in section \"My Tickets\". \n\nTime of drawing lots \n\nDrawing lots are held every 154 hours. The remaining time until the next lottery is indicated in the form of a countdown timer in each draw. \n\nDraw \n\nEach draw has its own unique serial number (identifier), according to which it can be found in the \"Statistics\" section. \n\nLottery broadcasting \n\nLottery broadcasting (numbers come up) can be viewed by going to the section of the desired lottery during the period when the countdown timer has reset. \n\nHow to check the ticket and get a win \n\nAfter the drawing the system automatically determines winning tickets. The winner of the lottery is responsible for the cost of GAS for getting wins. \n\nThe lottery organizer is responsible for the lottery costs. \n\nThe history of all drawing lots and payments made can be found in the \"Statistics\" section of each lottery. \n\nYou can check your winning tickets in section \"My Tickets\" by entering the number of the cryptowallet from which the lottery tickets were paid.",
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
            ], range: NSRange(location: 14, length: 25))
        
        attributedString.addAttributes([
            .font: UIFont(name: "OpenSans-Regular", size: 20.0)!,
            .foregroundColor: UIColor(red: 163.0 / 255.0, green: 143.0 / 255.0, blue: 187.0 / 255.0, alpha: 1.0)
            ], range: NSRange(location: 384, length: 21))
        
        attributedString.addAttributes([
            .font: UIFont(name: "OpenSans-Regular", size: 20.0)!,
            .foregroundColor: UIColor(red: 163.0 / 255.0, green: 143.0 / 255.0, blue: 187.0 / 255.0, alpha: 1.0)
            ], range: NSRange(location: 550, length: 4))
        
        attributedString.addAttributes([
            .font: UIFont(name: "OpenSans-Regular", size: 20.0)!,
            .foregroundColor: UIColor(red: 163.0 / 255.0, green: 143.0 / 255.0, blue: 187.0 / 255.0, alpha: 1.0)
            ], range: NSRange(location: 679, length: 21))
        
        attributedString.addAttributes([
            .font: UIFont(name: "OpenSans-Regular", size: 20.0)!,
            .foregroundColor: UIColor(red: 163.0 / 255.0, green: 143.0 / 255.0, blue: 187.0 / 255.0, alpha: 1.0)
            ], range: NSRange(location: 859, length: 38))
        
        howToPlayTextView.attributedText = attributedString;
    }
}
