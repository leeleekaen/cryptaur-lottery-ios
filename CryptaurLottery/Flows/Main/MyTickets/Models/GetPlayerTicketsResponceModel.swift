import Foundation


struct GetPlayerTicketsResponceModel: JSONDeserializable {
    
    let tickets: [Ticket]
    
    init?(json: JSONDictionary) {
        guard let list = json["tickets"] as? [JSONDictionary] else {
            return nil
        }
        
        var tickets = [Ticket]()
        for item in list {
            print("\(item)")
            guard let ticket = Ticket(json: item) else {
                return nil
            }
            tickets.append(ticket)
        }
        self.tickets = tickets
    }
}
