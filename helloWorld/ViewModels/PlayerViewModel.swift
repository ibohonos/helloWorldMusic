//
//  PlayerViewModel.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 13.08.2020.
//

import XCDYouTubeKit
import AVFoundation
import Foundation
import SwiftUI
import AVKit

class PlayerViewModel: NSObject, ObservableObject {
    @Published var showError = false
    @Published var errorMessage = Alert(title: Text("Error"), dismissButton: .cancel())
    @Published var isCollapsed = true
    @Published var viewPlayer = false
    @Published var currentProgress: TimeInterval = 0
    @Published var duration: TimeInterval = 1
    @Published var randomValues: [CGFloat] = (1...40).map({ _ in CGFloat.random(in: 1...10) })
    @Published var randomCurrentPlay: [CGFloat] = (1...10).map({ _ in CGFloat.random(in: 1...10) })
    @Published var song: Item = testItem
    @Published var artists: [Item] = []
    @Published var playlists: [PlaylistDatum] = []
    @Published var isLoadImage = false
    @Published var videoId: String?
    @Published var isPlayed = false
    @Published var isShuffled = false
    @Published var repearType: RepeatTypes = .none
    
    private var timeObserver: Any?

    var YPlayerViewController = AVPlayerViewController()
    var selectedType: TypeHomeList = .artists
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: YPlayerViewController.player?.currentItem)
        
        removeTimeObserver()
    }
}

extension PlayerViewModel {
    func removeTimeObserver() {
        if let token = timeObserver {
            YPlayerViewController.player?.removeTimeObserver(token)
            timeObserver = nil
        }
    }

    func randomizeSliderValues() {
        randomValues = (1...40).map({ _ in CGFloat.random(in: 1...10) })
    }
    
    func randomizeCurrentPlay() {
        withAnimation(.linear) {
            randomCurrentPlay = (1...10).map({ _ in CGFloat.random(in: 1...10) })
        }
    }
    
    func setupPlayer(song: Item, selectedType: TypeHomeList) {
        self.song = song
        self.selectedType = selectedType

        switch song.id {
            case let .string(id):
                videoId = id
            case let .innerItem(id):
                videoId = id.videoID
        }

        isLoadImage = true
        currentProgress = 0
        viewPlayer = true

        randomizeSliderValues()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isLoadImage = false
        }
    }

    func loadVideo() {
        guard let videoId = videoId else { return }
        
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: YPlayerViewController.player?.currentItem)
        
        if YPlayerViewController.player?.isPlaying ?? false {
            seek(0)
            YPlayerViewController.player?.pause()
        }
        
        removeTimeObserver()

//        viewControllerUtils.showActivityIndicator(uiView: view)
//        if let tabView = tabBarController?.view {
//            viewControllerUtils.showActivityIndicator(uiView: tabView)
//        }

//        stopTimer()
        
//        currTime?.text = getFormattedTime(timeInterval: 0)
//        timeSlider?.value = 0
//        popupItem.progress = 0
        
        XCDYouTubeClient.default().getVideoWithIdentifier(videoId) { (video, error) in
            guard error == nil else {
                print(error!.localizedDescription)

                self.errorMessage = .init(title: Text("Error"), message: Text(error!.localizedDescription), dismissButton: .cancel(Text("Ok")))
                self.showError = true
                self.isPlayed = false

                return
            }
            
            guard let video = video else { return }
            
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                AVPlayerViewControllerManager.shared.playerViewModel = self
                AVPlayerViewControllerManager.shared.video = video
                self.YPlayerViewController = AVPlayerViewControllerManager.shared.controller
                
                NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: self.YPlayerViewController.player?.currentItem)

//                self.setupTimer()
                
                let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
                
                self.timeObserver = self.YPlayerViewController.player?.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { (time) in
                    self.randomizeCurrentPlay()
                })
                
                self.YPlayerViewController.player?.play()
                self.isPlayed = true
            } catch let error {
                print(error.localizedDescription)
                self.errorMessage = .init(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .cancel(Text("Ok")))
                self.showError = true
                self.isPlayed = false
            }
            
//            self.viewControllerUtils.hideActivityIndicator(uiView: self.view)
//            if let tabView = self.tabBarController?.view {
//                self.viewControllerUtils.hideActivityIndicator(uiView: tabView)
//            }
        }
    }
}

extension PlayerViewModel {
    @objc func playerDidFinishPlaying(_ note: NSNotification) {
        // Your code here
        
        print("\(#function)")
        if repearType == .once {
            seek(0)
            YPlayerViewController.player?.play()
        } else {
            nextSoung()
        }
    }
    
    func seek(_ value: Double) {
        YPlayerViewController.player?.seek(to: CMTime(seconds: value, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
    }
    
    func playPause() {
        isPlayed.toggle()
        
        if isPlayed {
            YPlayerViewController.player?.play()
        } else {
            YPlayerViewController.player?.pause()
        }
    }
    
    func nextSoung() {
        switch selectedType {
            case .artists:
                let nextVideo = artists.firstIndex {
                    let videoId: String?

                    switch $0.id {
                        case let .string(id):
                            videoId = id
                        case let .innerItem(id):
                            videoId = id.videoID
                    }
                    
                    return videoId == self.videoId
                } ?? 0
                
                if nextVideo + 1 < artists.count {
                    if isShuffled {
                        var random = artists

                        random.shuffle()
                        setupPlayer(song: random[nextVideo + 1], selectedType: .artists)
                        loadVideo()
                    } else {
                        setupPlayer(song: artists[nextVideo + 1], selectedType: .artists)
                        loadVideo()
                    }
                } else {
                    if repearType == .enabled {
                        setupPlayer(song: artists[0], selectedType: .artists)
                        loadVideo()
                    } else {
                        isPlayed = false
                    }
                }
            default:
                break
        }
    }
    
    func prevSong() {
        switch selectedType {
            case .artists:
                let prevVideo = artists.firstIndex {
                    let videoId: String?

                    switch $0.id {
                        case let .string(id):
                            videoId = id
                        case let .innerItem(id):
                            videoId = id.videoID
                    }
                    
                    return videoId == self.videoId
                } ?? 0
                
                if prevVideo - 1 >= 0 {
                    if isShuffled {
                        var random = artists
                        
                        random.shuffle()
                        setupPlayer(song: random[prevVideo - 1], selectedType: .artists)
                        loadVideo()
                    } else {
                        setupPlayer(song: artists[prevVideo - 1], selectedType: .artists)
                        loadVideo()
                    }
                }
            default:
                break
        }
    }
}

#if DEBUG
var testItem = Item(kind: "youtube#searchResult", etag: "OjDDufFNxswN4MKaQvIhfhsdlKI", id: .innerItem(ID(kind: "youtube#video", videoID: "1FvEDuWeB4A", playlistID: nil)), snippet: Snippet(publishedAt: "2020-08-20T02:00:00Z", channelID: "UCDGmojLIoWpXok597xYo8cg", title: "Billie Eilish - my future (Live)", snippetDescription: "Register to vote: https://www.billieeilish.com/vote Listen to “my future”, out now: https://smarturl.it/myfuture Follow Billie Eilish: Facebook: ...", thumbnails: Thumbnails(thumbnailsDefault: Default(url: "https://i.ytimg.com/vi/1FvEDuWeB4A/default.jpg", width: 120, height: 90), medium: Default(url: "https://i.ytimg.com/vi/1FvEDuWeB4A/mqdefault.jpg", width: 320, height: 180), high: Default(url: "https://i.ytimg.com/vi/1FvEDuWeB4A/hqdefault.jpg", width: 480, height: 360)), channelTitle: "BillieEilishVEVO", liveBroadcastContent: "none", playlistID: nil, position: nil, resourceID: nil))
#endif
