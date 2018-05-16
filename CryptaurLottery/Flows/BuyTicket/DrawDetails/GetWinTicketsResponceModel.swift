import Foundation

struct GetWinTicketsResponceModel: JSONDeserializable {
    
    let tickets: [WinTicket]
    
    init?(json: JSONDictionary) {
        
        guard let list = json["tickets"] as? [JSONDictionary] else {
            return nil
        }
        
        var tickets = [WinTicket]()
        for item in list {
            guard let ticket = WinTicket(json: item) else {
                return nil
            }
            tickets.append(ticket)
        }
        self.tickets = tickets
    }
}
