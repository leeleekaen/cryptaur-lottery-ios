import Foundation

struct GetDrawsResponceModel: JSONDeserializable {
    
    let draws: [ArchiveDraw]
    
    init?(json: JSONDictionary) {
                
        guard let list = json["draws"] as? [JSONDictionary] else {
            return nil
        }
        
        var draws = [ArchiveDraw]()
        for item in list {
            guard let draw = ArchiveDraw(json: item) else {
                print(item)
                
                return nil
            }
            draws.append(draw)
        }
        
        self.draws = draws
    }
}
