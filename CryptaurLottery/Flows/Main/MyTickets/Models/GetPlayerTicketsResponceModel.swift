import Foundation


struct GetPlayerTicketsResponceModel: JSONDeserializable {
    
    let tickets: [Ticket]
    
    init?(json: JSONDictionary) {
        guard let list = json["tickets"] as? [JSONDictionary] else {
            return nil
        }
        
        var tickets = [Ticket]()
        //TODO: Count list Test
        //print("count list = \(list.count)")
        for item in list {
            //print("\(item)")
            guard let ticket = Ticket(json: item) else {
                return nil
            }
            tickets.append(ticket)
        }
        //print("tickets = \(tickets)")
        self.tickets = tickets
    }
}
