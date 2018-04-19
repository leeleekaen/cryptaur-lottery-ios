import UIKit

class MyTicketsCardCell: UICollectionViewCell {
    
    @IBOutlet var numbers: [UIButton]!
    
    func configure(for state: MyTicketsViewController.State) {
        
        switch state {
        case .active:
            print("active")
            numbers.forEach {
                $0.setBackgroundImage(#imageLiteral(resourceName: "number-button-background"), for: .normal)
            }
        case .played:
            print("played")
            numbers.forEach {
                $0.setBackgroundImage(#imageLiteral(resourceName: "loss_number-backgorund"), for: .normal)
            }
            numbers[2].setBackgroundImage(#imageLiteral(resourceName: "win-number-background"), for: .normal)
        }
    }
}
