//
//  CustomPlayerCoordinator.swift
//  LemonadeBoilerplate
//
//  Created by Özgür Elmaslı on 16.12.2021.
//

import Foundation

class CustomPlayerCoordinator: BaseCoordinator {
    var config: CustomPlayerControllerConfig = .init(miniPlayerEnabled: true, playerControllerButtonsEnabled: true)
    var playableSources: [Playable] = []
    var index: Int = 0
    
    override func start() {
        if playableSources.isEmpty { return }
        let viewModel: CustomPlayerViewModel = .init(coordinator: self, playableSources: playableSources, currentIndex: index, config: config)
        let viewController: CustomPlayerController = .init(viewModel: viewModel)
        config.miniPlayerEnabled
        ? addAsChild(viewController: viewController, removeAll: true)
        : navigationController?.pushViewController(viewController, animated: true)
    }
    
    func closePlayer() {
        config.miniPlayerEnabled ? removeAllChild() : pop(true)
    }
}
