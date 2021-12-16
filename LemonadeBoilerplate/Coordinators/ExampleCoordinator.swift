//
//  ExampleCoordinator.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 22.11.2021.
//

import UIKit

class ExampleCoordinator: BaseCoordinator {
    override func start() {
        let viewModel: ExampleViewModel = .init(coordinator: self)
        let exampleVC = ExampleViewController(viewModel: viewModel)
        let navigation: UINavigationController = .init(rootViewController: exampleVC)
        navigationController = navigation
        presenterViewController = exampleVC
        segue(viewController: navigation)
    }
    
    func startPlayer() {
        let coordinator: CustomPlayerCoordinator = .init()
        coordinator.config = .init(miniPlayerEnabled: true, playerControllerButtonsEnabled: true)
        let reddURL = Bundle.main.url(forResource: "redd", withExtension: ".mp3")
        let batuURL = Bundle.main.url(forResource: "batu", withExtension: ".mp3")
        coordinator.playableSources = [
            Source.init(type: .audio
                       , name: "Redd-Kanıyorduk"
                       , description: "Redd best albums"
                       , source: .init(imageURL: "http://images.genius.com/a990772dc7769e96a4c37f8b8483b49d.600x600x1.jpg", thumbmailURL: "http://images.genius.com/a990772dc7769e96a4c37f8b8483b49d.600x600x1.jpg", sourceURL: reddURL?.absoluteString ?? "")
                       , creator: .init(name: "Redd", description: "Redd", imageURL: "", thumbmailURL: "")),
            Source.init(type: .audio
                       , name: "İki Zavallı Kuş(feat Teoman)"
                       , description: "İki Zavallı Kuş(feat Teoman)"
                       , source: .init(imageURL: "https://i.scdn.co/image/ab67616d0000b2739a447164aa17c989451e73fb", thumbmailURL: "https://i.scdn.co/image/ab67616d0000b2739a447164aa17c989451e73fb", sourceURL: batuURL?.absoluteString ?? "")
                       , creator: .init(name: "Teoman", description: "Teoman", imageURL: "", thumbmailURL: ""))
        ]
        start(coordinator: coordinator)
    }
}

struct Source: Playable {
    var type: PlayerSourceType
    
    var name: String
    
    var description: String?
    
    var source: PlayerSource
    
    var creator: PlayerSourceCreator?
}
