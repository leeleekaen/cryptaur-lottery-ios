//
//  ShowRulesViewController.swift
//  CryptaurLottery
//
//  Created by Tim S on 20.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import UIKit
import CoreText

class ShowRulesViewController: BaseViewController {

    @IBOutlet weak var rulesTextView: UITextView!
    
    var lottery: LotteryID? {
        didSet {
            if let lottery = lottery {
                print("[ShowRulesViewController] set lottery: \(lottery)")
                configureText()
            }
        }
    }
    
    //Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureNavigationItem(showBalance: false)
        rulesTextView.backgroundColor = UIColor.darkTwo
        configureText()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rulesTextView.setContentOffset(CGPoint.zero, animated: false)
    }
}

//MARK: Setup View
private extension ShowRulesViewController {
    func configureText() {
        
        if lottery == nil {return}
        
        let attributedString = NSMutableAttributedString(string: "Participation\n\nTo participate in the lottery, you must choose any \(lottery?.toPick ?? 0) numbers out of \(lottery?.total ?? 0) in the playing field of the lottery ticket. The number of tickets is unlimited.\n\nTicket price\n\nThe cost of one ticket is determined by the lottery organizer and can be changed. Changes are allowed only after the end of the current drawing lot and before the next one. The ticket is paid by CPT tokens. The cost of GAS for the implementation of a transaction for the ticket purchase is not included in the ticket price and is debited from the participant`s wallet,  i. e. the participant should have enough ETH in the wallet for the ticket purchase. The cost of GAS can vary depending on the workload of the network Ethereum. The purchased tickets cannot be exchanged and returned.\n\nDistribution of funds\nfrom ticket sales\n\nThe funds raised from ticket sale in the current drawing lot are distributed as follows: 90% of the funds form the prize pool of the current draw; 10% of the funds - advertising, marketing, legal expenses, holding rallies.", attributes: [
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
        
        let separator = NSAttributedString(string: "\n\n")
        
        attributedString.append(separator)
        
        let distrHead = NSAttributedString(string: "Distribution of the prize pool \n\n", attributes: [.font: UIFont(name: "OpenSans-Regular", size: 16.0)!,
                                                                                                       .foregroundColor: UIColor(red: 163.0 / 255.0, green: 143.0 / 255.0, blue: 187.0 / 255.0, alpha: 1.0)])
        
        let distrBody = NSAttributedString(string: "The prize pool of the current drawing lot is divided into \((lottery?.toPick)! - 1) categories depending on the number of guessed numbers.", attributes: [.font: UIFont(name: "OpenSans-Regular", size: 16.0)!,
                                                                                                                                                                                                              .foregroundColor: UIColor(white: 1.0, alpha: 1.0)])
        
        attributedString.append(distrHead)
        attributedString.append(distrBody)
        attributedString.append(separator)
        
        var table = NSAttributedString()
        var tableBody = NSAttributedString()
        
        if lottery?.toPick == 4 {
            let html = """
                        <html>
                            <body>
                            <table style="width:100%; color:white; font-family:OpenSans-Regular;font-size:16px">
                                <tr>
                                    <th style="color:#a38fbb; width:30%">Numbers<br/>Matched</th>
                                    <th style="color:#a38fbb">Prize pool distribution</th>
                                </tr>
                                <tr>
                                    <td valign="middle"; style="font-size:26px; text-align:center">&#9315;</td>
                                    <td>Jackpot</td>
                                </tr>
                                <tr>
                                    <td valign="middle"; style="font-size:26px; text-align:center">&#9314;</td>
                                    <td>15% of the prize pool of the draw/ number of people who guessed 3 numbers<td>
                                </tr>
                                <tr>
                                    <td valign="middle"; style="font-size:26px; text-align:center">&#9313;</td>
                                    <td>25% of the prize pool of the draw/ number of people who guessed 2 numbers</td>
                                </tr>
                            </table>
                            </body>
                        </html>
            """
            let data = Data(html.utf8)
            if let tmpString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                tableBody = tmpString
            }
            
        }
        if lottery?.toPick == 5 {
            let html = """
                        <html>
                            <body>
                            <table style="width:100%; color:white; font-family:OpenSans-Regular;font-size:16px">
                                <tr>
                                    <th style="color:#a38fbb; width:30%">Numbers<br/>Matched</th>
                                    <th style="color:#a38fbb">Prize pool distribution</th>
                                </tr>
                                <tr>
                                    <td valign="middle"; style="font-size:26px; text-align:center">&#9316;</td>
                                    <td>Jackpot</td>
                                </tr>
                                <tr>
                                    <td valign="middle"; style="font-size:26px; text-align:center">&#9315;</td>
                                    <td>10% of the prize pool of the draw/ number of people who guessed 4 numbers<td>
                                </tr>
                                <tr>
                                    <td valign="middle"; style="font-size:26px; text-align:center">&#9314;</td>
                                    <td>10% of the prize pool of the draw/ number of people who guessed 3 numbers</td>
                                </tr>
                                <tr>
                                    <td valign="middle"; style="font-size:26px; text-align:center">&#9313;</td>
                                    <td>20% of the prize pool of the draw/ number of people who guessed 2 numbers</td>
                                </tr>
                            </table>
                            </body>
                        </html>
            """
            let data = Data(html.utf8)
            if let tmpString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                tableBody = tmpString
            }
        }
        if lottery?.toPick == 6 {
            let html = """
                        <html>
                            <body>
                            <table style="width:100%; color:white; font-family:OpenSans-Regular;font-size:16px">
                                <tr>
                                    <th style="color:#a38fbb; width:30%">Numbers<br/>Matched</th>
                                    <th style="color:#a38fbb">Prize pool distribution</th>
                                </tr>
                                <tr>
                                    <td valign="middle"; style="font-size:26px; text-align:center">&#9317;</td>
                                    <td>Jackpot</td>
                                </tr>
                                <tr>
                                    <td valign="middle"; style="font-size:26px; text-align:center">&#9316;</td>
                                    <td>5% of the prize pool of the draw/ number of people who guessed 5 numbers</td>
                                </tr>
                                <tr>
                                    <td valign="middle"; style="font-size:26px; text-align:center">&#9315;</td>
                                    <td>5% of the prize pool of the draw/ number of people who guessed 4 numbers<td>
                                </tr>
                                <tr>
                                    <td valign="middle"; style="font-size:26px; text-align:center">&#9314;</td>
                                    <td>10% of the prize pool of the draw/ number of people who guessed 3 numbers</td>
                                </tr>
                                <tr>
                                    <td valign="middle"; style="font-size:26px; text-align:center">&#9313;</td>
                                    <td>20% of the prize pool of the draw/ number of people who guessed 2 numbers</td>
                                </tr>
                            </table>
                            </body>
                        </html>
            """
            let data = Data(html.utf8)
            if let tmpString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                tableBody = tmpString
            }
        }
        
        attributedString.append(table)
        attributedString.append(separator)
        attributedString.append(tableBody)
        
        let distrBody2 = NSAttributedString(string: "If there are no winners the sum goes to the Jackpot of the next draw. \n\n 50% of the prize pool of category \(lottery?.toPick ?? 0) always goes to the Jackpot of the next draw. \n\n The jackpot, accumulated over previous draws, divides tickets among themselves, in which \(lottery?.total ?? 0) numbers are guessed. If there are none the current jackpot amount is added to the next drawdown Jackpot. \n\n The minimum guaranteed \(lottery?.toPick ?? 0) out of \(lottery?.total ?? 0) lottery jackpot is determined by the lottery organizer and can be changed. Changes are allowed only after the end of the current draw and before the next one. \n\n In case the Jackpot won is less than the minimum jackpot amount, the required balance is taken from the reserve fund. After that all the funds intended for replenishment of the Jackpot of the following drawing lots go first to repay the amount taken from the reserve fund. The reserve fund initially accumulates at the expense of fees to the Jackpot, as well as at the expense of funds contributed by the lottery organizer.",
            attributes: [.font: UIFont(name: "OpenSans-Regular", size: 16.0)!,
                         .foregroundColor: UIColor(white: 1.0, alpha: 1.0)])
        
        attributedString.append(separator)
        attributedString.append(distrBody2)
        attributedString.append(separator)
        
        
        let drawHead = NSAttributedString(string: "Draw \n\n", attributes: [.font: UIFont(name: "OpenSans-Regular", size: 16.0)!,
                                                                            .foregroundColor: UIColor(red: 163.0 / 255.0, green: 143.0 / 255.0, blue: 187.0 / 255.0, alpha: 1.0)])
        
        let drawBody = NSAttributedString(string: "The lottery is held every 154 hours. The time of the nearest draw is indicated in the lottery ticket. Ticket sale for draw ends 1 hour before its start.\n\n",
                                          attributes: [.font: UIFont(name: "OpenSans-Regular", size: 16.0)!,
                                                       .foregroundColor: UIColor(white: 1.0, alpha: 1.0)])
        
        attributedString.append(drawHead)
        attributedString.append(drawBody)
        
        let payoutHead = NSAttributedString(string: "Payout \n\n", attributes: [.font: UIFont(name: "OpenSans-Regular", size: 16.0)!,
                                                                                .foregroundColor: UIColor(red: 163.0 / 255.0, green: 143.0 / 255.0, blue: 187.0 / 255.0, alpha: 1.0)])
        
        let payoutBody = NSAttributedString(string: "After the draw the system automatically determines winning tickets. The owner of the winning ticket should apply for a win before the next draw, otherwise the ticket is cancelled. The winner of the lottery shall pay the gas for getting the win. \n\n The lottery organizer is responsible for lottery costs.\n\n",
                                            attributes: [.font: UIFont(name: "OpenSans-Regular", size: 16.0)!,
                                                         .foregroundColor: UIColor(white: 1.0, alpha: 1.0)])
        
        attributedString.append(payoutHead)
        attributedString.append(payoutBody)
        
        let taxesHead = NSAttributedString(string: "Taxes \n\n", attributes: [.font: UIFont(name: "OpenSans-Regular", size: 16.0)!,
                                                                              .foregroundColor: UIColor(red: 163.0 / 255.0, green: 143.0 / 255.0, blue: 187.0 / 255.0, alpha: 1.0)])
        
        let taxesBody = NSAttributedString(string: "The Cryptaur project does not act as a tax agent. The duty to pay taxes rests with the owner of the cryptowallet where the payout was made.\n\n",
                                           attributes: [.font: UIFont(name: "OpenSans-Regular", size: 16.0)!,
                                                        .foregroundColor: UIColor(white: 1.0, alpha: 1.0)])
        
        attributedString.append(taxesHead)
        attributedString.append(taxesBody)
        
        let agrHead = NSAttributedString(string: "Agreement \n\n", attributes: [.font: UIFont(name: "OpenSans-Regular", size: 16.0)!,
                                                                                .foregroundColor: UIColor(red: 163.0 / 255.0, green: 143.0 / 255.0, blue: 187.0 / 255.0, alpha: 1.0)])
        
        let agrBody = NSAttributedString(string: "Taking part in the lottery, you agree with the rules of its conduct. You guarantee that at the time of purchasing a lottery ticket you turned 18 or you have reached another minimum age required to participate in the lottery provided for by the law of the country of your permanent residence.\n\n",
                                         attributes: [.font: UIFont(name: "OpenSans-Regular", size: 16.0)!,
                                                      .foregroundColor: UIColor(white: 1.0, alpha: 1.0)])
        
        attributedString.append(agrHead)
        attributedString.append(agrBody)
        
        rulesTextView.attributedText = attributedString;
    }
}

