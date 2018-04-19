import UIKit

class MyTicketsCardCell: UICollectionViewCell {
    
    @IBOutlet var numbers: [UIButton]!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var wonLabel: UILabel!
    
    func configure(for state: MyTicketsViewController.State) {
        
        switch state {
        case .active:
            timeLeftLabel.isHidden = false
            dateLabel.isHidden = true
            wonLabel.isHidden = true
            numbers.forEach { $0.setBackgroundImage(#imageLiteral(resourceName: "number-button-background"), for: .normal) }
        case .played:
            timeLeftLabel.isHidden = true
            dateLabel.isHidden = false
            wonLabel.isHidden = false
            numbers.forEach { $0.setBackgroundImage(#imageLiteral(resourceName: "loss_number-backgorund"), for: .normal) }
            numbers[1].setBackgroundImage(#imageLiteral(resourceName: "win-number-background"), for: .normal)
        }
    }
}
