import UIKit

class LotteryCardCell: UICollectionViewCell {
    
    @IBOutlet weak var ballsImage: UIImageView!
    
    func configure(draw: Draw) {
        
        guard let lottery = LotteryID(rawValue: draw.lotteryID) else { return }
        
        switch lottery {
        case .lottery4x20:
            ballsImage.image = #imageLiteral(resourceName: "balls 4x20 large")
        case .lottery5x36:
            ballsImage.image = #imageLiteral(resourceName: "balls-5x36 large")
        case .lottery6x42:
            ballsImage.image = #imageLiteral(resourceName: "balls 6x42 large")
        }
    }
}
