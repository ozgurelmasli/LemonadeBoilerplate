//
//  CustomPlayerViewModel.swift
//  LemonadeBoilerplate
//
//  Created by Özgür Elmaslı on 16.12.2021.
//

import Foundation

class CustomPlayerViewModel: BaseViewModel<CustomPlayerCoordinator> {
    private var playableSources: [Playable] = []
    var currentIndex: Int = 0
    
    var sourceURLs: [String] {
        return playableSources.map { $0.source.sourceURL }
    }
    var currentPlayableSource: Playable {
        return playableSources[currentIndex]
    }
    
    func next() {
        currentIndex += 1
        if currentIndex > playableSources.count - 1 {
            currentIndex = playableSources.count - 1 
        }
    }
    func prev() {
        currentIndex -= 1
        if currentIndex < 0 {
            currentIndex = 0
        }
    }
    
    var config: CustomPlayerControllerConfig?
    
    convenience init(coordinator: CustomPlayerCoordinator, playableSources: [Playable], currentIndex: Int = 0, config: CustomPlayerControllerConfig) {
        self.init(coordinator: coordinator)
        self.playableSources = playableSources
        self.currentIndex = currentIndex
        self.config = config
    }
    
    func closePlayer() {
        safeCoordinator.closePlayer()
    }
    
}
