import Foundation

extension Int {
    
    var timeString: String {
        
        guard self >= 0 else { return "0" }
        
        let hours = self / (60*60)
        let minutes = (self - hours * (60*60)) / 60
        let seconds = (self - hours * (60*60) - minutes * 60)
        
        return "\(twoDecimal(hours)):\(twoDecimal(minutes)):\(twoDecimal(seconds))"
    }
    
    private func twoDecimal(_ number: Int) -> String {
        if number < 10 {
            return "0\(number)"
        } else {
            return "\(number)"
        }
    }
}
