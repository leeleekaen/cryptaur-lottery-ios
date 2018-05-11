import UIKit
import UInt256

class MyTicketsCardCell: UICollectionViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var drawIndexLabel: UILabel!
    @IBOutlet weak var numbersStack: UIStackView!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var wonLabel: UILabel!
    @IBOutlet weak var lotteryBalls: UIImageView!
    
    // MARK: - Private properties
    let dateFormatter = DateFormatter()
    
    // MARK: - Configure
    func configure(state: MyTicketsViewController.State, ticket: Ticket) {
        
        drawIndexLabel.text = "DRAW #\(ticket.drawIndex)"
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateLabel.text = dateFormatter.string(from: ticket.date)
        
        switch ticket.numbers.count {
        case 4:
            lotteryBalls.image = #imageLiteral(resourceName: "balls 4x20 large")
        case 5:
            lotteryBalls.image = #imageLiteral(resourceName: "balls-5x36 large")
        case 6:
            lotteryBalls.image = #imageLiteral(resourceName: "balls 6x42 large")
        default:
            fatalError("unexpected count of numbers in ticket")
        }
        
        if ticket.winAmount == UInt256(integerLiteral: 0) {
            wonLabel.text = "0 CPT"
        } else {
            var winAmount = ticket.winAmount.toStringWithDelimeters()
            winAmount.removeLast(5)
            wonLabel.text = winAmount + " CPT"
        }
        
        switch state {
        case .active:
            timeLeftLabel.isHidden = true
            dateLabel.isHidden = false
            wonLabel.isHidden = false
            
            numbersStack.removeAllArrangedSubviews()
            
            ticket.numbers.forEach {
                let button = UIButton()
                button.setTitle("\(abs($0))", for: .normal)
                button.setBackgroundImage(#imageLiteral(resourceName: "number-button-background"), for: .normal)
                numbersStack.addArrangedSubview(button)
            }
            
        case .played:
            timeLeftLabel.isHidden = true
            dateLabel.isHidden = false
            wonLabel.isHidden = false
            
            numbersStack.removeAllArrangedSubviews()
            
            ticket.numbers.forEach {
                let button = UIButton()
                button.setTitle("\(abs($0))", for: .normal)
                if $0 < 0 {
                    button.setBackgroundImage(#imageLiteral(resourceName: "win-number-background"), for: .normal)
                    
                } else {
                    button.setBackgroundImage(#imageLiteral(resourceName: "loss_number-backgorund"), for: .normal)
                }
                numbersStack.addArrangedSubview(button)
            }
            
        }
    }
}
