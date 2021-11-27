//
//  Trackable.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 27.11.2021.
//

protocol Trackable {
    var identifier : String { get }
    var params : [String : Any] { get }
    var services : [TrackerService] { get }
    
    func track()
}
extension Trackable {
    func track(){
        for service in services {
            switch service {
            case .firebase:
                //Analytics.logEvent(trackable.identifier, parameters: trackable.params)
                break
            case .mixPanel:
                break
            }
        }
    }
}




enum TrackerService {
    case firebase
    case mixPanel
}
