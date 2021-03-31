import Foundation

class Dict {
    class func fetchData() -> [Word]? {
        // 
        
        // Open the JSON file
        if let path = Bundle.main.path(forResource: "words", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let words = try JSONDecoder().decode([Word].self, from: data)
                
                return words
            } catch {
                // fatalError("Can't open JSON")
                return []
            }
        }
        return nil
    }
}
