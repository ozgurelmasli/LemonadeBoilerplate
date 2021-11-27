//
//  ShortCutParser.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 24.11.2021.
//

import UIKit

protocol ShortCutIdentifiable {
    var localTitle: String { get }
    var localSubtitle: String { get }
    var iconName: String { get }
}
enum ShortCut: Identifiable, ShortCutIdentifiable, CaseIterable {
    var localTitle: String {
        return "Example local title"
    }
    
    var localSubtitle: String {
        return "Example subtitle"
    }
    
    var iconName: String {
        "pencil.slash"
    }
    
    case exampleShortCut
    
    var id: String {
        return "exampleShortCut"
    }
}

class ShortCutParser {
    private static var referance: ShortCutParser? = ShortCutParser()
    
    static var shared: ShortCutParser {
        if referance == nil { referance  = ShortCutParser() }
        return referance!
    }
    
    func register() {
        let shortCuts = ShortCut.allCases.map { shortcut in
            UIApplicationShortcutItem(type: shortcut.id
                                      , localizedTitle: shortcut.localTitle
                                      , localizedSubtitle: shortcut.localSubtitle
                                      , icon: UIApplicationShortcutIcon(systemImageName: shortcut.iconName)
                                      , userInfo: nil)
        }
        UIApplication.shared.shortcutItems = shortCuts
    }
    
    func parseShortCut(shortcut: UIApplicationShortcutItem) -> DeepLink? {
        switch shortcut.type {
        case ShortCut.exampleShortCut.id:
            return .exampleAction(action: .exampleAction(actionId: "exampleId"))
        default:
            return nil
        }
    }
}
