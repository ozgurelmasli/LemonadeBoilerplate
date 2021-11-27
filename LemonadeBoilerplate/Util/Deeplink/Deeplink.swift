//
//  Deeplink.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 24.11.2021.
//

enum DeepLink {
    enum ExampleDeepLinkAction: Identifiable {
        case exampleAction(actionId: String)
        
        var id: String {
            return "exampleIdentifier"
        }
    }
    
    case exampleAction(action: DeepLink.ExampleDeepLinkAction)
}
