import Foundation
import UInt256

struct BuyTicketRequestModel {
    let authKey: String
    let lottery: LotteryID
    let numbers: [Int]
    let drawIndex: Int
    let playerAddress: UInt256
}
