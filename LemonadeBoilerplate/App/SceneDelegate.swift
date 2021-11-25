//
//  SceneDelegate.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 21.11.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        self.appCoordinator = .init(scene: scene)
        self.appCoordinator?.start()
    }
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(DeepLinkHandler.shared.handleShortCut(shortCut: shortcutItem))
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}
