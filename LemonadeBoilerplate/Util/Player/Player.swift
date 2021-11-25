//
//  Player.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 22.11.2021.
//

import Foundation
import AVKit

enum PlayerSlideAction {
    case slide(value: CGFloat)
    case next15Seconds
    case prev15Seconds
}

protocol CustomPlayerDelegate: AnyObject {
    func didPlayerPaused()
    func didPlayerPlayed()
    func didDurationChanged( _ second: Int, _ minute: Int)
    func didTotalDurationChanged( _ duration: Float64)
    func didPlayerStateChanged( _ state: AVKeyValueStatus)
}

class CustomPlayer: NSObject {
    
    weak var customPlayerActionDelegate: CustomPlayerDelegate?
    
    var volume: Float = 0.5 {
        didSet {
            self.player?.volume = volume
        }
    }
    
    var isLoopEnabled: Bool = false
    
    private var currentPlayingItemIndex: Int = 0
    private var assetURLs: [String] = []
    
    private var assets: AVURLAsset?
    private var player: AVQueuePlayer?
    private var playerItem: AVPlayerItem?
    private var playerLooper: AVPlayerLooper?
    private var remotePlayer: CustomRemotePlayer?
    private var timeObserver: Any?
    
    init( _ url: String) {
        super.init()
        assetURLs = [url]
        remotePlayer = .init()
        remotePlayer?.customRemotePlayerActionDelegate = self
    }
    init( _ urls: [String]) {
        super.init()
        assetURLs = urls
        remotePlayer = .init()
        remotePlayer?.customRemotePlayerActionDelegate = self
    }
    private var playerURL: URL? {
        return URL(string: assetURLs[currentPlayingItemIndex])
    }
    private var assetOptions: [String: [String: String]] {
        return [
            "AVURLAssetHTTPHeaderFieldsKey": [
                "session": "Bearer ",
                "Authorization": "Bearer "
            ]
        ]
    }
}

extension CustomPlayer {
    private func playerConfiguration() {
        guard let url =  playerURL else { return }
        assets     = AVURLAsset(url: url, options: assetOptions)
        playerItem = AVPlayerItem(asset: assets!)
        player     = AVQueuePlayer(playerItem: playerItem!)
        player?.automaticallyWaitsToMinimizeStalling = false
        if isLoopEnabled {
            playerLooper = AVPlayerLooper(player: player!, templateItem: playerItem!)
        }
        assets?.loadValuesAsynchronously(forKeys: ["playable"], completionHandler: { [weak self] in
            var error: NSError?
            guard let status = self?.assets?.statusOfValue(forKey: "playable", error: &error) else { return }
            switch status {
            case .loaded:
                self?.customPlayerActionDelegate?.didTotalDurationChanged(CMTimeGetSeconds(self?.playerItem?.asset.duration ?? CMTime.zero))
                self?.remotePlayer?.changePlayerData(self?.player?.currentTime().seconds ?? 0.0, self?.playerItem?.asset.duration.seconds ?? 0.0, self?.player?.rate ?? 0.0)
                self?.customPlayerActionDelegate?.didPlayerStateChanged(status)
                self?.timeObserver =  self?.player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: .main, using: { cmtime in
                    let time: Float64 = CMTimeGetSeconds(cmtime)
                    let second = Int(time) % 60
                    let minute = Int(time) / 60
                    self?.customPlayerActionDelegate?.didDurationChanged(second, minute)
                })
            default:
                self?.customPlayerActionDelegate?.didPlayerStateChanged(status)
            }
            
        })
    }
}

// MARK: Core
extension CustomPlayer {
    func next( _ url: String? = nil) {
        reset()
        clear()
        currentPlayingItemIndex += 1
        if let url = url {
            assetURLs = [url]
            currentPlayingItemIndex = 0
        }
        if currentPlayingItemIndex > assetURLs.count - 1 { currentPlayingItemIndex = assetURLs.count - 1 }
        playerConfiguration()
    }
    
    func previous( _ url: String? = nil) {
        reset()
        clear()
        currentPlayingItemIndex += 1
        if let url = url {
            assetURLs = [url]
            currentPlayingItemIndex = 0
        }
        if currentPlayingItemIndex < 0 { currentPlayingItemIndex = 0 }
        playerConfiguration()
    }
    
    func play() {
        self.player?.play()
        self.customPlayerActionDelegate?.didPlayerPlayed()
    }
    func pause() {
        self.player?.play()
        self.customPlayerActionDelegate?.didPlayerPaused()
    }
    func reset() {
        self.player?.pause()
        self.player?.seek(to: .zero)
        self.customPlayerActionDelegate?.didDurationChanged(0, 0)
        self.customPlayerActionDelegate?.didTotalDurationChanged(0.0)
        // NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    func slide(action: PlayerSlideAction) {
        pause()
        let slideValue: CMTime
        switch action {
        case .slide(let value):
            slideValue = CMTime(seconds: Double(value), preferredTimescale: 1000)
        case .next15Seconds:
            let newTime = CMTimeGetSeconds(player!.currentTime()) + 15
            slideValue = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        case .prev15Seconds:
            var newTime = CMTimeGetSeconds(player!.currentTime()) - 15
            if newTime < 0.0 { newTime = 0.0 }
            slideValue = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        }
        player?.seek(to: slideValue)
        play()
    }
    func clear() {
        player?.removeTimeObserver(self.timeObserver as Any)
        playerItem?.cancelPendingSeeks()
        playerItem?.asset.cancelLoading()
        remotePlayer?.clear()
        playerItem = nil
        player = nil
        assets = nil
        customPlayerActionDelegate = nil
        timeObserver = nil
    }
}

// MARK: Remote Control

extension CustomPlayer: CustomRemotePlayerAction {
    func playCommand() {
        play()
    }
    
    func pauseCommand() {
        pause()
    }
    
    func nextTrackCommand() {
        next()
    }
    
    func previousTrackCommand() {
        previous()
    }
    
    func slideCommand(_ value: CGFloat) {
        slide(action: .slide(value: value))
    }
}
