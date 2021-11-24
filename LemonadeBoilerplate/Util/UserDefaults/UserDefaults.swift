//
//  UserDefaults.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 21.11.2021.
//

import Foundation

extension UserDefaults {
    func get<T>( _ type : T.Type , tag : UserdefaultsTag) -> T? {
        guard let object = self.object(forKey: tag.buildTag()) as? T else { return nil }
        return object
    }
    func set<T>( _ data : T , tag : UserdefaultsTag) {
        self.setValue(data, forKey: tag.buildTag())
        synchronize()
    }
    func delete( _ tag : UserdefaultsTag){
        self.removeObject(forKey: tag.buildTag())
        self.synchronize()
    }
    func reset(){
        let dict = dictionaryRepresentation() as NSDictionary
        for key in dict.allKeys { removeObject(forKey: key as! String) }
        synchronize()
    }
}
