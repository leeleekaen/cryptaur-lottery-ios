import Foundation
import UInt256

struct ConnectTokenResponseModel: JSONDeserializable {
    let accessToken: String
    let expiresIn: Int
    let tokenType: String
    let refreshToken: String
    let address: UInt256

    
    init?(json: JSONDictionary) {
        guard let accessToken = json["access_token"] as? String,
            let addressString = json["address"] as? String,
            let address = UInt256(hexString: addressString),
        let expiresIn = json["expires_in"] as? Int,
        let tokenType = json["token_type"] as? String,
        let refreshToken = json["refresh_token"] as? String else {
                return nil
        }
        
        self.accessToken = accessToken
        self.expiresIn = expiresIn
        self.tokenType = tokenType
        self.refreshToken = refreshToken
        self.address = address
    }
}
