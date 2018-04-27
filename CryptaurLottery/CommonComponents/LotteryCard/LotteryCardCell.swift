import UIKit
import UInt256

class LotteryCardCell: UICollectionViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var ballsImage: UIImageView!
    @IBOutlet weak var drawIndexLabel: UILabel!
    @IBOutlet weak var jackpotLabel: UILabel!
    @IBOutlet weak var buyTicketButton: UIButton! {
        didSet {
            buyTicketButton.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var timeLeftLabel: UILabel!
    
    // MARK: - IBAction
    @IBAction func buyTicket(_ sender: UIButton) {
        if let lottery = lottery {
            buyTicketCompletion?(lottery)
        }
    }
    var buyTicketCompletion: ((_ lottery: LotteryID) -> ())?
    
    // MARK: - Private property
    var lottery: LotteryID?
    
    // MARK: - Configure
    func configure(draw: Draw) {
        
        // Balls image
        guard let lottery = LotteryID(rawValue: draw.lotteryID) else { return }
        self.lottery = lottery
        
        switch lottery {
        case .lottery4x20:
            ballsImage.image = #imageLiteral(resourceName: "balls 4x20 large")
        case .lottery5x36:
            ballsImage.image = #imageLiteral(resourceName: "balls-5x36 large")
        case .lottery6x42:
            ballsImage.image = #imageLiteral(resourceName: "balls 6x42 large")
        }
        
        // Draw number
        drawIndexLabel.text = "DRAW #\(draw.number)"
        
        // Jackpot
        var jackpot = draw.jackpot.toStringWithDelimeters()
        if draw.jackpot != UInt256(integerLiteral: 0) {
            jackpot.removeLast(5)
        }
        jackpotLabel.text = jackpot + " CPT"
        
        // Buy ticket
        var ticketPrice = draw.ticketPrice.toStringWithDelimeters()
        if draw.ticketPrice != UInt256(integerLiteral: 0) {
            ticketPrice.removeLast(5)
        }
        buyTicketButton.setTitle("Buy ticket for \(ticketPrice) CPT", for: .normal)
        
        // Time left
        let secondsLetf = Int(draw.date.timeIntervalSinceNow)
        timeLeftLabel.text = "TIME LEFT \(secondsLetf.timeString)"
    }
}
