//
//  IndexViewModel.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 15.07.2020.
//

import Foundation
import SwiftUI

class IndexViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var Charts: AppleCharts = .init(results: .init(songs: nil, albums: nil, playlists: nil))
    @Published var showError = false
    @Published var errorMessage = Alert(title: Text("Error"), dismissButton: .cancel())
    
    var artistColumn = [
        GridItem(.fixed(220)),
        GridItem(.fixed(220))
    ]
    var playlistColumn = [GridItem(.fixed(220))]
    
    var Artists: [TopArtists] = [
        .init(name: "Billie Eilish", image: "Billie_Eilish"),
        .init(name: "Cardi B", image: "Cardi_B"),
        .init(name: "Imagine Dragons", image: "Imagine_Dragons"),
        .init(name: "Taylor Swift", image: "Taylor_Swift"),
        .init(name: "Jason Derulo", image: "Jason_Derulo"),
        .init(name: "Kety Perry", image: "Kety_Perry"),
        .init(name: "Shakira", image: "Shakira"),
        .init(name: "Ed Sheeran", image: "Ed_Sheeran"),
        .init(name: "Enrique Iglesias", image: "Enrique_Iglesias"),
        .init(name: "Selena Gomez", image: "Selena_Gomez")
    ]
    
    func getData() {
        let endpoint = APIService.Endpoint.getCharts
        var params = endpoint.params()
        
        params["types"] = "songs,albums,playlists"
        
        APIService.shared
            .send(
                endpoint: endpoint,
                method: .get,
                params: params,
                headers: endpoint.headers(),
                baseURL: .AppleMusicUrl
            )
        { (result: Result<AppleCharts, APIService.APIError>) in
            switch result {
                case let .success(response):
                    #if DEBUG
                        print(response)
                    #endif
                    self.Charts = response
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
