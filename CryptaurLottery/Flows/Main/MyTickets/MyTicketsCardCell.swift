import UIKit

class MyTicketsCardCell: UICollectionViewCell {
    
    @IBOutlet weak var numbersStack: UIStackView!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var wonLabel: UILabel!
    
    func configure(state: MyTicketsViewController.State, ticket: Ticket) {
        
        switch state {
        case .active:
            timeLeftLabel.isHidden = false
            dateLabel.isHidden = true
            wonLabel.isHidden = true
            
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
