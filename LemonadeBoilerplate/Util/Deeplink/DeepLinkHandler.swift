//
//  DeepLinkHandler.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 24.11.2021.
//

import Foundation
import UIKit


class DeepLinkHandler {
    
    var deepLink : DeepLink?
    
    private static var referance : DeepLinkHandler? = DeepLinkHandler()
    
    static var shared: DeepLinkHandler {
        if referance == nil { referance  = DeepLinkHandler() }
        return referance!
    }
    
    func handleShortCut(shortCut : UIApplicationShortcutItem) -> Bool {
        deepLink = ShortCutParser.shared.parseShortCut(shortcut: shortCut)
        if deepLink != nil {
            UserDefaults.standard.set(true, tag: DeepLinkTag.hasDeepLink)
        }
        return deepLink != nil
    }
    
    func handleLocalNotification(userInfo : [AnyHashable : Any]) {
        //....
        deepLink = .exampleAction(action: .exampleAction(actionId: "exampleId"))
        UserDefaults.standard.set(true, tag: DeepLinkTag.hasDeepLink)
    }
    
    func handlePushNotification(){
        //MARK: One signal implementation
        UserDefaults.standard.set(true, tag: DeepLinkTag.hasDeepLink)
    }
}
