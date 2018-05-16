import Foundation
import UInt256

struct GetWinTicketsRequestModel {
    let lotteryID: LotteryID
    let drawIndex: UInt
    let offset: UInt
    let count: UInt
}
