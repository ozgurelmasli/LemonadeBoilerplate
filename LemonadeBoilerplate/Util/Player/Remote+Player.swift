//
//  Remote+Player.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 23.11.2021.
//

import UIKit
import MediaPlayer

protocol CustomRemotePlayerAction : AnyObject {
    func playCommand()
    func pauseCommand()
    func nextTrackCommand()
    func previousTrackCommand()
    func slideCommand( _ value : CGFloat)
}

class CustomRemotePlayer {
    weak var customRemotePlayerActionDelegate : CustomRemotePlayerAction?
    
    private var nowPlayingInfo = [String : Any]()
    
    init(){
        setupRemoteTransportControls()
    }
    deinit {
        nowPlayingInfo = [:]
        customRemotePlayerActionDelegate = nil
        clearRemoteControls()
    }
    
    func changePlayerUI(playerTitle : String , albumTitle : String , image :UIImage? = nil , imageURL : URL?){
        nowPlayingInfo[MPMediaItemPropertyTitle] = playerTitle
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = albumTitle
        if let image = image {
            self.nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: CGSize(width: 300, height: 300)) { size in
                return image
            }
        }
        // if let imageURL = imageURL {
        //     let fakeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        //    fakeImageView.sd_setImage(with: imageURL) { (image, err, type, url) in
        //        self.nowPlayingInfo[MPMediaItemPropertyArtwork] =
        //        MPMediaItemArtwork(boundsSize: CGSize(width: 300, height: 300)) { size in
        //            return image ?? UIImage()
        //        }
        //    }
        // }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func changePlayerData( _ seconds : Double , _ duration : Double , _ rate : Float ){
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = rate
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func clear(){
        nowPlayingInfo = [:]
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    private func clearRemoteControls(){
        MPRemoteCommandCenter.shared().playCommand.removeTarget(self, action: nil)
        MPRemoteCommandCenter.shared().pauseCommand.removeTarget(self, action: nil)
        MPRemoteCommandCenter.shared().nextTrackCommand.removeTarget(self, action: nil)
        MPRemoteCommandCenter.shared().previousTrackCommand.removeTarget(self, action: nil)
        MPRemoteCommandCenter.shared().changePlaybackPositionCommand.removeTarget(self, action: nil)
    }
    private  func setupRemoteTransportControls() {
            // Get the shared MPRemoteCommandCenter
            let commandCenter = MPRemoteCommandCenter.shared()
            
            // Add handler for Play Command
            commandCenter.playCommand.addTarget { [weak self] event in
                guard let self = self else { return .commandFailed }
                self.customRemotePlayerActionDelegate?.playCommand()
                return .success
            }
            
            // Add handler for Pause Command
            commandCenter.pauseCommand.addTarget { [weak self] event in
                guard let self = self else { return .commandFailed }
                self.customRemotePlayerActionDelegate?.pauseCommand()
                return .success
            }
            commandCenter.nextTrackCommand.addTarget{ [weak self] event in
                guard let self = self else { return .commandFailed }
                self.customRemotePlayerActionDelegate?.nextTrackCommand()
                return .success
            }
            commandCenter.previousTrackCommand.addTarget{ [weak self] event in
                guard let self = self else { return .commandFailed }
                self.customRemotePlayerActionDelegate?.previousTrackCommand()
                return .success
            }
            commandCenter.changePlaybackPositionCommand.addTarget { [weak self] event in
                guard let self = self else { return .commandFailed }
                self.customRemotePlayerActionDelegate?.slideCommand(CGFloat((event as? MPChangePlaybackPositionCommandEvent)?.positionTime ?? 0.0))
                return .success
            }
        }
}

