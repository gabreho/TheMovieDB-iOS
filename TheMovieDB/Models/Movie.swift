//
//  Movie.swift
//  TheMovieDB
//
//  Created by Gabriel Hernández on 11/10/18.
//  Copyright © 2018 gabreho. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON


class Movie: MovieApiObject {
    @objc dynamic var title = ""
    @objc dynamic var overview = ""
    @objc dynamic var posterPath = ""
    @objc dynamic var backdropPath = ""
    @objc dynamic var releaseDate = Date()
    @objc dynamic var voteAverage = 0.0

    static var releaseDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }
    
    convenience required init(with json: JSON) {
        self.init()
        
        self.title = json["title"].stringValue
        self.overview = json["overview"].stringValue
        self.posterPath = json["poster_path"].stringValue
        self.backdropPath = json["backdrop_path"].stringValue
        self.voteAverage = json["vote_average"].doubleValue
        
        let strReleaseDate = json["release_date"].stringValue
        self.releaseDate = Movie.releaseDateFormatter.date(from: strReleaseDate) ?? Date()
        
    }
}

//{
//    "poster_path": "/e1mjopzAS2KNsvpbpahQ1a6SkSn.jpg",
//    "adult": false,
//    "overview": "",
//    "release_date": "2016-08-03",
//    "genre_ids": [
//    14,
//    28,
//    80
//    ],
//    "id": 297761,
//    "original_title": "Suicide Squad",
//    "original_language": "en",
//    "title": "Suicide Squad",
//    "backdrop_path": "/ndlQ2Cuc3cjTL7lTynw6I4boP4S.jpg",
//    "popularity": 48.261451,
//    "vote_count": 1466,
//    "video": false,
//    "vote_average": 5.91
//}
