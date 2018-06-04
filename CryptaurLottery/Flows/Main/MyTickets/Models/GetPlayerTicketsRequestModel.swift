import Foundation
import UInt256

struct GetPlayerTicketsRequestModel {
    let playerAddress: UInt256
    let lotteryID: LotteryID
    let offset: UInt
    let count: UInt
}
