//
//  DataManager.swift
//  Get Your Playlist
//
//  Created by Radasia Waltower on 11/24/18.
//  Copyright © 2018 Team 6. All rights reserved.
//

import Foundation
import UIKit
import Parse

class DataManager: NSObject {
    
    var token = ""
    
    static let sharedInstance = DataManager()
    
    private let defaultSession = URLSession(configuration: .default)
    
    private var dataTask: URLSessionDataTask?
    
    
    func getSongSearchResults(searchTerm: String, completion: @escaping ([Song]?) -> Void) {
        dataTask?.cancel()
        guard let  escapedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            completion(nil)
            return
        }
        
        PFConfig.getInBackground {
            ( config: PFConfig?, error: Error?) -> Void in
            var configData = config
            if error == nil {
                print("Yay! Config was fetched from the server.")
            } else {
                print("Failed to fetch. Using Cached Config.")
                configData = PFConfig.current()
            }
            
            self.token = (configData?["developer_token"] as? String)!
            
            if var urlComponents = URLComponents(string: "https://api.music.apple.com/v1/catalog/us/search") {
                urlComponents.query = "term=\(escapedSearchTerm)&types=songs&limit=1"
                
                guard let url = urlComponents.url else {
                    completion(nil)
                    return
                }
                
                var request = URLRequest(url: url)
                request.addValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
                
                self.dataTask = self.defaultSession.dataTask(with: request) {(data, response, error ) in
                    guard error == nil else {
                        print("Error")
                        completion(nil)
                        return
                    }
                    
                    guard let content = data else {
                        print("No data")
                        completion(nil)
                        return
                    }
                    print("Results: \(content)")
                    let jsonDecoder = JSONDecoder()
                    guard let songs = (try? jsonDecoder.decode(Results.self, from: content))?.songs else {
                        print("Decoding error")
                        completion(nil)
                        return
                    }
                    completion(songs)
                }
                self.dataTask?.resume()
            }
        }
    }
    
    func getGenreSearchResults(searchTerm: String, completion: @escaping ([Genre]?) -> Void) {
        dataTask?.cancel()
        guard let  escapedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            completion(nil)
            return
        }
        
        PFConfig.getInBackground {
            ( config: PFConfig?, error: Error?) -> Void in
            var configData = config
            if error == nil {
                print("Yay! Config was fetched from the server.")
            } else {
                print("Failed to fetch. Using Cached Config.")
                configData = PFConfig.current()
            }
            
            self.token = (configData?["developer_token"] as? String)!
            
            if let urlComponents = URLComponents(string: "https://api.music.apple.com/v1/catalog/us/genres") {
                
                guard let url = urlComponents.url else {
                    completion(nil)
                    return
                }
                
                var request = URLRequest(url: url)
                request.addValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")

                self.dataTask = self.defaultSession.dataTask(with: request) {(data, response, error ) in
                    guard error == nil else {
                        print("Error")
                        completion(nil)
                        return
                    }
                    
                    guard let content = data else {
                        print("No data")
                        completion(nil)
                        return
                    }
                    
                    let jsonDecoder = JSONDecoder()
                    guard var genres = (try? jsonDecoder.decode(GenreResults.self, from: content))?.genres else {
                        print("Decoding error")
                        completion(nil)
                        return
                    }
                    do {
                        genres = try self.filterGenreResults(searchText: escapedSearchTerm, genres: genres)
                    } catch {
                        print("cant't filter genres")
                    }
                    
                    completion(genres)
                }
                self.dataTask?.resume()
            }
        }
    }
    
    func filterGenreResults(searchText: String, genres: [Genre]) throws -> [Genre] {
        
        var filtered: [Genre] = []
        filtered = genres.filter({(genre: Genre) -> Bool in
            return genre.name.lowercased().contains(searchText.lowercased())
            
        })
        
        return filtered
    }


    
    func getArtistSearchResults(searchTerm: String, completion: @escaping ([Artist]?) -> Void) {
        dataTask?.cancel()
        guard let  escapedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            completion(nil)
            return
        }
        
        PFConfig.getInBackground {
            ( config: PFConfig?, error: Error?) -> Void in
            var configData = config
            if error == nil {
                print("Yay! Config was fetched from the server.")
            } else {
                print("Failed to fetch. Using Cached Config.")
                configData = PFConfig.current()
            }
            
            self.token = (configData?["developer_token"] as? String)!
            
            if var urlComponents = URLComponents(string: "https://api.music.apple.com/v1/catalog/us/search") {
                urlComponents.query = "term=\(escapedSearchTerm)&types=artists&limit=25"
                
                guard let url = urlComponents.url else {
                    completion(nil)
                    return
                }
                
                var request = URLRequest(url: url)
                request.addValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
                
                self.dataTask = self.defaultSession.dataTask(with: request) {(data, response, error ) in
                    guard error == nil else {
                        print("Error")
                        completion(nil)
                        return
                    }
                    
                    guard let content = data else {
                        print("No data")
                        completion(nil)
                        return
                    }
                    let jsonDecoder = JSONDecoder()
                    guard let artists = (try? jsonDecoder.decode(ArtistResults.self, from: content))?.artists else {
                        print("Decoding error")
                        completion(nil)
                        return
                    }
                    completion(artists)
                }
                self.dataTask?.resume()
            }
        }
    }
        
        
}
