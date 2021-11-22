//
//  StaticJSON.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 22.11.2021.
//
import Foundation


enum StaticFile : String {
    
    case exampleFile  = "exampleFileName"
    
    var fileType : String {
        return "json"
    }
    var filePath : String?  {
        return Bundle.main.path(forResource: self.rawValue, ofType: fileType)
    }
}
extension StaticFile {
    func JSON<T : Codable>(convert : T.Type) -> T? {
        guard let path = filePath else { return nil }
        do {
            let url = URL.init(fileURLWithPath: path)
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            let decoder = JSONDecoder.init()
            let model = try decoder.decode(T.self, from: data)
            return model
        }catch {
            return nil
        }
    }
}
