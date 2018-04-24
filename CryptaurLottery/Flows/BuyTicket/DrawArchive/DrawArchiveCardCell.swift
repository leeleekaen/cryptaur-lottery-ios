import UIKit
import UInt256

class DrawArchiveCardCell: UICollectionViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var drawNumberLabel: UILabel!
    @IBOutlet weak var numbersStackView: UIStackView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var jackpotLabel: UILabel!
    
    // MARK: - Private properties
    let dateFormatter = DateFormatter()
    
    // MARK: - Configure
    func configure(with draw: ArchiveDraw) {
        
        drawNumberLabel.text = "DRAW #\(draw.number)"
        if draw.jackpot == UInt256(integerLiteral: 0) {
            jackpotLabel.text = "0 CPT"
        } else {
            var jackpot = draw.jackpot.toStringWithDelimeters()
            jackpot.removeLast(5)
            jackpotLabel.text = jackpot + " CPT"
        }
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateLabel.text = dateFormatter.string(from: draw.date)
        
        let removedSubviews = numbersStackView.arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            numbersStackView.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
        
        draw.numbers?.forEach {
            let button = UIButton()
            button.setTitle("\($0)", for: .normal)
            button.setBackgroundImage(#imageLiteral(resourceName: "loss_number-backgorund"), for: .normal)
            numbersStackView.addArrangedSubview(button)
        }
    }
}
