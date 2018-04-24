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
        
        drawNumberLabel.text = "DRAW #1\(draw.number)"
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
    }
}
