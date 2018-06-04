import Foundation
import UIKit

struct ConnectTokenRequestModel {
    let grantType = "password"
    let username: String
    let password: String
    let deviceID = UIDevice.current.identifierForVendor?.uuidString
    let pin: String?
    let scope = "lottery_main offline_access"
    let withPin: Bool
}
