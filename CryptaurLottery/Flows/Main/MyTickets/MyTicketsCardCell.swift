import UIKit

class MyTicketsCardCell: UICollectionViewCell {
    
    func configure(for state: MyTicketsViewController.State) {
        
        switch state {
        case .active:
            print("active")
        case .played:
            print("played")
        }
    }
}
