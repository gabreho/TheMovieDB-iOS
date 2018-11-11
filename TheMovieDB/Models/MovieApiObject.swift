//
//  MovieApiObject.swift
//  TheMovieDB
//
//  Created by Gabriel Hernández on 11/10/18.
//  Copyright © 2018 gabreho. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class MovieApiObject: Object {
    
    static func == (lhs: MovieApiObject, rhs: MovieApiObject) -> Bool {
        return lhs.id == rhs.id
    }
    
    @objc dynamic var id = ""
    
    convenience required init(with json: JSON) {
        self.init()
        
        self.id = json["id"].stringValue
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
