//
//  ExampleTracker.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 27.11.2021.
//

enum ExampleTracker: Trackable {
    case exampleTrackAction
    
    var identifier: String {
        return "exampleTrackAction"
    }
    
    var params: [String : Any] {
        return ["exampleId" : "1234"]
    }
    
    var services: [TrackerService] {
        return [ .firebase , .mixPanel ]
    }
}
