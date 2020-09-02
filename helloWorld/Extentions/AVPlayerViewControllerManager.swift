//
//  AVPlayerViewControllerManager.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 18.08.2020.
//

import Foundation
import AVKit
import MediaPlayer
import XCDYouTubeKit

extension AVPlayer {
    var isPlaying: Bool {
        if (self.rate != 0 && self.error == nil) {
            return true
        } else {
            return false
        }
    }
}

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
}

@objcMembers class AVPlayerViewControllerManager: NSObject {
    //MARK: - Public
    public static let shared = AVPlayerViewControllerManager()
    public var lowQualityMode = false
    public dynamic var duration: Double = 0
    
    public var playerViewModel: PlayerViewModel?
    
    public var video: XCDYouTubeVideo? {
        didSet {
            guard let video = video else { return }
            guard lowQualityMode == false else {
                guard let streamURL = video.streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] ?? video.streamURLs[XCDYouTubeVideoQuality.medium360.rawValue] ?? video.streamURLs[XCDYouTubeVideoQuality.small240.rawValue] else { fatalError("No stream URL") }
                
                self.player = AVPlayer(url: streamURL)
                self.controller.player = self.player
                return
            }
            guard let streamURL = video.streamURL else { fatalError("No stream URL") }
            self.player = AVPlayer(url: streamURL)
            self.controller.player = self.player
        }
    }

    public var player: AVPlayer? {
        didSet {
            if let playerRateObserverToken = playerRateObserverToken {
                playerRateObserverToken.invalidate()
                self.playerRateObserverToken = nil
            }
            
            self.playerRateObserverToken = player?.observe(\.rate, changeHandler: { (item, value) in
                self.updatePlaybackRateMetadata()
            })
            
            guard let video = self.video else { return }
            if let token = timeObserverToken {
                oldValue?.removeTimeObserver(token)
                timeObserverToken = nil
            }
            self.setupRemoteTransportControls()
            self.updateGeneralMetadata(video: video)
            self.updatePlaybackDuration()
        }
    }
    
    public lazy var controller: AVPlayerViewController = {
        let controller = AVPlayerViewController()

        if #available(iOS 10.0, *) {
            controller.updatesNowPlayingInfoCenter = false
        }

        return controller
    }()
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(forName: AVAudioSession.interruptionNotification, object:  AVAudioSession.sharedInstance(), queue: .main) { (notification) in
            
            guard let userInfo = notification.userInfo,
                let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
                let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                    return
            }
            
            if type == .began {
//                self.player?.pause()
                self.playerViewModel?.playPause()
            } else if type == .ended {
                guard ((try? AVAudioSession.sharedInstance().setActive(true)) != nil) else { return }
                guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                guard options.contains(.shouldResume) else { return }
//                self.player?.play()
                self.playerViewModel?.playPause()
            }
        }
    }
    
    public func disconnectPlayer() {
        self.controller.player = nil
    }
    
    public func reconnectPlayer(rootViewController: UIViewController) {
        let viewController = rootViewController.topMostViewController()
        guard let playerViewController = viewController as? AVPlayerViewController else {
            if rootViewController is UINavigationController {
                guard let vc = (rootViewController as! UINavigationController).visibleViewController else { return }
                for childVC in vc.children  {
                    guard let playerViewController = childVC as? AVPlayerViewController else { continue }
                    playerViewController.player = self.player
                    break
                }
            }
            return
        }
        playerViewController.player = self.player
    }
    
    //MARK: - Private
    
    fileprivate var playerRateObserverToken: NSKeyValueObservation?
    fileprivate var timeObserverToken: Any?
    fileprivate let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
    
    fileprivate func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.player?.rate == 0.0 {
                self.player?.play()
                return .success
            }
            return .commandFailed
        }

        commandCenter.pauseCommand.addTarget { event in
            if self.player?.rate == 1.0 {
                self.player?.pause()
                return .success
            }
            return .commandFailed
        }
    }
    
    fileprivate func updateGeneralMetadata(video: XCDYouTubeVideo) {
        guard player?.currentItem != nil else {
            nowPlayingInfoCenter.nowPlayingInfo = nil
            return
        }
        
        var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
        let title = video.title
        
        if let thumbnailURL = video.thumbnailURLs?.first {
            URLSession.shared.dataTask(with: thumbnailURL) { (data, _, error) in
                guard error == nil else { return }
                guard let data = data else { return }
                guard let image = UIImage(data: data) else { return }
                
                let artwork = MPMediaItemArtwork(boundsSize: CGSize()) { (size) -> UIImage in
                    return image
                }
                
//                let artwork = MPMediaItemArtwork(image: image)
                nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
                self.nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
            }.resume()
        }
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
    
    fileprivate func updatePlaybackDuration() {
        let interval = CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        timeObserverToken = self.player?.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: {  [weak self] (time) in
            guard let self = self else { return }
            guard let player = self.player else { return }
            guard let currentItem = player.currentItem else { return }
            
            var nowPlayingInfo = self.nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()

            self.duration = Double(CMTimeGetSeconds(currentItem.duration))
            self.playerViewModel?.duration = CMTimeGetSeconds(currentItem.duration)
            self.playerViewModel?.currentProgress = CMTimeGetSeconds(currentItem.currentTime())

            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = self.duration
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(currentItem.currentTime())

            self.nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
        })
    }
    
    fileprivate func updatePlaybackRateMetadata() {
        guard player?.currentItem != nil else {
            duration = 0
            nowPlayingInfoCenter.nowPlayingInfo = nil
            return
        }
        
        var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()

        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player!.rate
        nowPlayingInfo[MPNowPlayingInfoPropertyDefaultPlaybackRate] = player!.rate
    }
}
