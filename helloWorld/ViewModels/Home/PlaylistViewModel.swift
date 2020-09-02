//
//  PlaylistViewModel.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 16.07.2020.
//

import Foundation
import SwiftUI

class PlaylistViewModel: ObservableObject {
    @Published var showError = false
    @Published var errorMessage = Alert(title: Text("Error"), dismissButton: .cancel())
    @Published var artist: TopArtists?
    @Published var playlist: PlaylistDatum?
    @Published var selectedType: TypeHomeList = .artists
    @Published var id: String?
    @Published var artists: YouTubeSearch?
    @Published var playlists: AppleMusicPlaylist?
    @Published var playlistVideo: YouTubeSearch?
    
    func fetchPlaylistItems() {
        let endpoint = APIService.Endpoint.search
        var params = endpoint.params()
        
        if let artist = id {
            params["q"] = artist
        }
        
//        viewControllerUtils.showActivityIndicator(uiView: view)
        
        APIService.shared
            .send(
                endpoint: endpoint,
                method: .get,
                params: params,
                headers: endpoint.headers(),
                baseURL: .YouTubeUrl
            )
        { (result: Result<YouTubeSearch, APIService.APIError>) in
            switch result {
                case let .success(response):
                    #if DEBUG
                        print(response)
                    #endif
                    self.artists = response
//                    DispatchQueue.main.async {
//                        self.playlistTableView.reloadData()
//                        self.songCount()
//                    }
                case let .failure(error):
                    let (title, err, code) = getErrorMessage(error)

                    if code == 403 || code >= 500 {
                        self.errorMessage = .init(title: Text(title), message: Text("Please, check your internet connection and try again"), dismissButton: .default(Text("OK")))
                    } else {
                        self.errorMessage = .init(title: Text(title), message: Text(err), dismissButton: .default(Text("OK")))
                    }

                    self.showError = true

                    print("title = \(title)")
                    print("err = \(err)")
                    break
            }
            
//            self.viewControllerUtils.hideActivityIndicator(uiView: self.view)
        }
    }
    
    func fetchSongs() {
        let endpoint = APIService.Endpoint.getPlaylist(id: id ?? "")
        
//        viewControllerUtils.showActivityIndicator(uiView: view)
        
        APIService.shared
            .send(
                endpoint: endpoint,
                method: .get,
                params: endpoint.params(),
                headers: endpoint.headers(),
                baseURL: .AppleMusicUrl
            )
        { (result: Result<AppleMusicPlaylist, APIService.APIError>) in
            switch result {
                case let .success(response):
                    #if DEBUG
                        print(response)
                    #endif
                    self.playlists = response
//                    DispatchQueue.main.async {
//                        self.playlistTableView.reloadData()
//                        self.songCount()
//                    }
                    
                case let .failure(error):
                    let (title, err, code) = getErrorMessage(error)

                    if code == 403 || code >= 500 {
                        self.errorMessage = .init(title: Text(title), message: Text("Please, check your internet connection and try again"), dismissButton: .default(Text("OK")))
                    } else {
                        self.errorMessage = .init(title: Text(title), message: Text(err), dismissButton: .default(Text("OK")))
                    }

                    self.showError = true

                    print("title = \(title)")
                    print("err = \(err)")
                    break
            }
            
//            self.viewControllerUtils.hideActivityIndicator(uiView: self.view)
        }
    }
    
    func fetchSongsPlaylist(_ name: String) {
        let endpoint = APIService.Endpoint.search
        var params = endpoint.params()
        
        params["q"] = name
        
        APIService.shared
            .send(
                endpoint: endpoint,
                method: .get,
                params: params,
                headers: endpoint.headers(),
                baseURL: .YouTubeUrl
            )
        { (result: Result<YouTubeSearch, APIService.APIError>) in
            switch result {
                case let .success(response):
                    #if DEBUG
                        print(response)
                    #endif
                    self.playlistVideo = response
//                    self.songCount()
                case let .failure(error):
                    let (title, err, code) = getErrorMessage(error)

                    if code == 403 || code >= 500 {
                        self.errorMessage = .init(title: Text(title), message: Text("Please, check your internet connection and try again"), dismissButton: .default(Text("OK")))
                    } else {
                        self.errorMessage = .init(title: Text(title), message: Text(err), dismissButton: .default(Text("OK")))
                    }

                    self.showError = true

                    print("title = \(title)")
                    print("err = \(err)")
                    break
            }
        }
    }
}
