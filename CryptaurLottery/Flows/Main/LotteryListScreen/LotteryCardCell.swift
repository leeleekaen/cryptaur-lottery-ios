import UIKit
import UInt256

protocol LotteryCardCellDelegate: class {
    
    func lotteryCardCellAction(cell: LotteryCardCell, buttonPressed: UIButton)
}

class LotteryCardCell: UICollectionViewCell {
    
    weak var delegate: LotteryCardCellDelegate?
    
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
    
    //Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Private property
    public private(set) var draw: Draw?
    
    // MARK: - Configure
    func configure(draw: Draw) {
        self.draw = draw
        // Balls image
        guard let lottery = LotteryID(rawValue: draw.lotteryID) else { return }
        
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
        
        setupButton(draw: draw)
        
        // Time left
        let secondsLetf = Int(draw.date.timeIntervalSinceNow)
        timeLeftLabel.text = "TIME LEFT \(secondsLetf.timeString)"
    }
}

//MARK: Setup View
fileprivate extension LotteryCardCell {
    func setupButton(draw: Draw) {
        // Buy ticket
        var ticketPrice = draw.ticketPrice.toStringWithDelimeters()
        if draw.ticketPrice != UInt256(integerLiteral: 0) {
            ticketPrice.removeLast(5)
        }
        if draw.drawState == .played {
            buyTicketButton.setTitle("Playing", for: .normal)
        }else {
            buyTicketButton.setTitle("Buy ticket for \(ticketPrice) CPT", for: .normal)
        }
    }
}

// MARK: - IBAction
extension LotteryCardCell {
    @IBAction func buyTicket(_ sender: UIButton) {
        guard let drawValue = draw else {
            return
        }
        if drawValue.drawState == .played {
            return
        }
        
        delegate?.lotteryCardCellAction(cell: self, buttonPressed: sender)
    }
}
