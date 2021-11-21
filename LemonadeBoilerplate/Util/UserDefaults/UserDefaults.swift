//
//  UserDefaults.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 21.11.2021.
//

import Foundation

extension UserDefaults {
    public func get<T>( _ type : T.Type , tag : UserdefaultsTag) -> T? {
        guard let object = self.object(forKey: tag.buildTag()) as? T else { return nil }
        return object
    }
    public func set<T>( _ data : T , tag : UserdefaultsTag) {
        self.setValue(data, forKey: tag.buildTag())
        synchronize()
    }
    public func delete( _ tag : UserdefaultsTag){
        self.removeObject(forKey: tag.buildTag())
        self.synchronize()
    }
    public func reset(){
        let dict = dictionaryRepresentation() as NSDictionary
        for key in dict.allKeys { removeObject(forKey: key as! String) }
        synchronize()
    }
}
