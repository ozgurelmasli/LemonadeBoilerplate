//
//  AppCoordinator.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 22.11.2021.
//

import UIKit

final class AppCoordinator : BaseCoordinator {
    var window : UIWindow?
    
    public init(scene : UIWindowScene) {
        self.window = .init(windowScene: scene)
    }
    override func start() {
        let coordinator : ExampleCoordinator = .init()
        start(coordinator: coordinator)
    }
}
