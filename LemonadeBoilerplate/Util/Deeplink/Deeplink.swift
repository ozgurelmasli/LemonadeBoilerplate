//
//  Deeplink.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 24.11.2021.
//

protocol ParsableDeepLink {
    var identifier: String { get }
}

enum DeepLink {
    enum ExampleDeepLinkAction: ParsableDeepLink {
        case exampleAction(actionId: String)
        
        var identifier: String {
            return "exampleIdentifier"
        }
    }
    
    case exampleAction(action: DeepLink.ExampleDeepLinkAction)
}
