/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The `AppleMusicRequestFactory` type is used to build the various Apple Music API calls used by the sample.
*/

import Foundation

struct AppleMusicRequestFactory {
    
    // MARK: Types
    
    /// The base URL for all Apple Music API network calls.
    static let appleMusicAPIBaseURLString = "api.music.apple.com"
    
    /// The Apple Music API endpoint for requesting a list of recently played items.
    static let recentlyPlayedPathURLString = "/v1/me/recent/played"
    
    /// The Apple Music API endpoint for requesting a the storefront of the currently logged in iTunes Store account.
    static let userStorefrontPathURLString = "/v1/me/storefront"
    
    static let artistsPathURLString = "/v1/me/library/artists"
    
    static let genresPathURLString = "/v1/me/library/genres"
        
    static func createSearchRequest(with term: String, developerToken: String) -> URLRequest {
        
        // Create the URL components for the network call.
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = AppleMusicRequestFactory.appleMusicAPIBaseURLString
        urlComponents.path = "/v1/catalog/us/search"
        
        let expectedTerms = term.replacingOccurrences(of: " ", with: "+")
        let urlParameters = ["term": expectedTerms,
                             "limit": "1",
                             "types": "songs"]
        
        var queryItems = [URLQueryItem]()
        for (key, value) in urlParameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        urlComponents.queryItems = queryItems
        
        // Create and configure the `URLRequest`.
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = "GET"
        
        urlRequest.addValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
        
        return urlRequest
    }
    
    static func createStorefrontsRequest(regionCode: String, developerToken: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = AppleMusicRequestFactory.appleMusicAPIBaseURLString
        urlComponents.path = "/v1/storefronts/\(regionCode)"
        
        // Create and configure the `URLRequest`.
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = "GET"
        
        urlRequest.addValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
        
        return urlRequest
    }
    
    static func createGetArtistsRequest(developerToken: String, userToken: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = AppleMusicRequestFactory.appleMusicAPIBaseURLString
        urlComponents.path = AppleMusicRequestFactory.artistsPathURLString
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = "GET"
        
        urlRequest.addValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue(userToken, forHTTPHeaderField: "Music-User-Token")
        
        
        return urlRequest
    }
    
    static func createGetGenresRequest(developerToken: String, userToken: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = AppleMusicRequestFactory.appleMusicAPIBaseURLString
        urlComponents.path = AppleMusicRequestFactory.genresPathURLString
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = "GET"
        
        urlRequest.addValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue(userToken, forHTTPHeaderField: "Music-User-Token")
        
        
        return urlRequest
    }
    
    static func createRecentlyPlayedRequest(developerToken: String, userToken: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = AppleMusicRequestFactory.appleMusicAPIBaseURLString
        urlComponents.path = AppleMusicRequestFactory.recentlyPlayedPathURLString
        
        // Create and configure the `URLRequest`.
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = "GET"
        
        urlRequest.addValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue(userToken, forHTTPHeaderField: "Music-User-Token")
        
        return urlRequest
    }
    
    static func createGetUserStorefrontRequest(developerToken: String, userToken: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = AppleMusicRequestFactory.appleMusicAPIBaseURLString
        urlComponents.path = AppleMusicRequestFactory.userStorefrontPathURLString
        
        // Create and configure the `URLRequest`.
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = "GET"
        
        urlRequest.addValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue(userToken, forHTTPHeaderField: "Music-User-Token")
        
        return urlRequest
    }
}