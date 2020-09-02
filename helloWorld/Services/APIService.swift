//
//  APIService.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 15.07.2020.
//

import Foundation

// MARK: - APIService
struct APIService {
    static let shared = APIService()
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
//    static let appleMusicAPIKey = "eyJhbGciOiJFUzI1NiIsImtpZCI6IlMzUzJXMjlSOUQifQ.eyJpc3MiOiJUMjI4WFk2Nkg3IiwiaWF0IjoxNTg4NDUyMDI1LCJleHAiOjE2MDQwMDQwMjV9.GDDKLnw52wshSvP-PbIw6-N5vtnJut47vrjdaMdhZ9DB-Rr3-qRuw_OR8rxeySVAxhpkiXsW84oTCREb5sMQXw"
    
    static let appleMusicAPIKey = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjRKUUQzNTNEV1IifQ.eyJpYXQiOjE1OTU3MDAyNTIsImV4cCI6MTYxMTI1MjI1MiwiaXNzIjoiVFBHNVVTWlRNUyJ9.wWTgp6wI_S5mmzkT7jYTHBA8tq1gt0mscXbLRshjg5JqByNWTmqGYyvQ6mFE7MSCO5Hd0Ac0bAungdltgjRVPQ"
    
    enum BaseUrl {
        case YouTubeUrl, GoogleSearch, AppleMusicUrl
        
        func getUrl() -> URL? {
            switch self {
                case .YouTubeUrl: return URL(string: "https://www.googleapis.com/youtube/v3")
                case .GoogleSearch: return URL(string: "https://suggestqueries.google.com")
                case .AppleMusicUrl: return URL(string: "https://api.music.apple.com")
            }
        }
    }
    
    enum APIError: Error {
        case noResponse
        case jsonDecodingError(error: Error)
        case dataError(error: YouTubeErrors)
        case appleDataError(error: AppleErrors)
        case networkError(error: Error)
    }
    
    enum HttpMethod: String {
        case get, post, put, patch, delete
        
        func method() -> String {
            switch self {
                case .get: return "GET"
                case .post: return "POST"
                case .put: return "PUT"
                case .patch: return "PATCH"
                case .delete: return "DELETE"
            }
        }
    }
    
    enum Endpoint {
        case channels, search, playlistItems
        case getTopGenres, getGenre(id: String), getCharts, getSong(id: String), getPlaylist(id: String)
        case searchByApple
        case searchSugg
        
        func path() -> String {
            switch self {
                case .channels: return "channels"
                case .search: return "search"
                case .playlistItems: return "playlistItems"
                case .getTopGenres: return "v1/catalog/us/genres"
                case .searchByApple: return "v1/catalog/us/search"
                case let .getGenre(id): return "v1/catalog/us/genres/\(id)/artist"
                case .getCharts: return "v1/catalog/us/charts"
                case let .getSong(id): return "v1/catalog/us/songs/\(id)"
                case let .getPlaylist(id): return "v1/catalog/us/playlists/\(id)"
                case .searchSugg: return "complete/search"
            }
        }
        
        func params() -> [String: Any] {
//            let youtubeApiKey = "AIzaSyDuV5TxngXLDNAXjX3bsA6d614c0Y_o9rk"
            let youtubeApiKey = "AIzaSyCRgRl0wr0-bbY3hvyfbtawRtkeBpeecJ4"
            let yCategoryID = "GCTXVzaWM" // YouTubeMusicCategory

            switch self {
                case .channels:
                    return [
                        "part" : "snippet",
                        "categoryId": yCategoryID,
                        "key" : youtubeApiKey
                    ]
                case .search:
                    return [
                        "part" : "snippet",
                        "maxResults" : "25",
                        "type" : "video",
                        "videoCategoryId" : "10",
                        "key" : youtubeApiKey
                    ]
                case .playlistItems:
                    return [
                        "part" : "snippet",
                        "maxResults" : "25",
                        "key" : youtubeApiKey
                    ]
                case .getTopGenres:
                    return [
                        "limit": "20"
                    ]
                case .getCharts:
                    return [
                        "limit": "20"
                    ]
                case .searchByApple:
                    return [
                        "limit": "20"
                    ]
                case .searchSugg:
                    return [
                        "client": "firefox",
                        "ds": "yt"
                    ]
                default: return [:]
            }
        }
        
        func headers() -> [String: String] {
            switch self {
                case .getTopGenres: return ["Authorization" : "Bearer \(APIService.appleMusicAPIKey)"]
                case .getGenre: return ["Authorization" : "Bearer \(APIService.appleMusicAPIKey)"]
                case .getCharts: return ["Authorization" : "Bearer \(APIService.appleMusicAPIKey)"]
                case .getSong: return ["Authorization" : "Bearer \(APIService.appleMusicAPIKey)"]
                case .getPlaylist: return ["Authorization" : "Bearer \(APIService.appleMusicAPIKey)"]
                case .searchByApple: return ["Authorization" : "Bearer \(APIService.appleMusicAPIKey)"]
                default: return [:]
            }
        }
    }
    
    func send<T: Codable>(endpoint: Endpoint,
                          method: HttpMethod = .get,
                          params: [String: Any],
                          headers: [String: String],
                          baseURL: BaseUrl = .YouTubeUrl,
                          completionHandler: @escaping (Result<T, APIError>) -> Void) {

        guard let queryURL = baseURL.getUrl()?.appendingPathComponent(endpoint.path()) else { return }
        var components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)!
        components.queryItems = []
        if method == .get {
            for (_, value) in params.enumerated() {
                components.queryItems?.append(URLQueryItem(name: value.key, value: value.value as? String))
            }
        }

        var request = URLRequest(url: components.url!)
        request.httpMethod = method.method()
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if method != .get {
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        }
        for (_, value) in headers.enumerated() {
            request.addValue(value.value, forHTTPHeaderField: value.key)
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.networkError(error: error!)))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.noResponse))
                }
                return
            }
            do {
                print("url: \(request.url?.absoluteString ?? "")")
//                if method != .get {
//                    print("httpBody: \(String(data: request.httpBody!, encoding: .utf8)!)")
//                }
//                print("method: \(method.rawValue)")
//                print("dataString \(String(data: data, encoding: .utf8) ?? "nil")")
//                print("key: \(request.value(forHTTPHeaderField: "Authorization") ?? "")")
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode >= 400 {
                        if httpResponse.statusCode == 401 {
                            DispatchQueue.main.async {
                                completionHandler(.failure(.noResponse))
                            }
                            return
                        }
                        var res: Codable
                        if baseURL == .YouTubeUrl {
                            res = try self.decoder.decode(YouTubeErrors.self, from: data)
                        } else {
                            res = try self.decoder.decode(AppleErrors.self, from: data)
                        }
                        #if DEBUG
                            print("Error: \(res)")
                        #endif

                        if baseURL == .YouTubeUrl {
                            DispatchQueue.main.async {
                                completionHandler(.failure(.dataError(error: res as! YouTubeErrors)))
                            }
                        } else {
                            DispatchQueue.main.async {
                                completionHandler(.failure(.appleDataError(error: res as! AppleErrors)))
                            }
                        }
                        return
                    }
                }
                let object = try self.decoder.decode(T.self, from: data)

                DispatchQueue.main.async {
                    completionHandler(.success(object))
                }
            } catch let error {
                DispatchQueue.main.async {
                    #if DEBUG
                        print("JSON Decoding Error: \(error)")
                    #endif

                    completionHandler(.failure(.jsonDecodingError(error: error)))
                }
            }
        }
        task.resume()
    }
}
