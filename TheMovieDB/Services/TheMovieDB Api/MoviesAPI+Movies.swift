//
//  MoviesAPI+Movies.swift
//  TheMovieDB
//
//  Created by Gabriel Hernández on 11/10/18.
//  Copyright © 2018 gabreho. All rights reserved.
//

import Foundation

extension MoviesAPI {
    
    enum Movies: APIEndpoint {
        typealias APIResponseType = PagedResponse<Movie>
        
        var endpoint: String {
            switch self {
            case .nowPlaying:
                return "/movie/now_playing"
            case .topRated:
                return "/movie/top_rated"
            }
        }
        
        var method: String {
            // same method for the current two api calls
            return "GET"
        }
        
        case nowPlaying()
        case topRated()
        
    }
}
