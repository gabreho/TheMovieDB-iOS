//
//  Response.swift
//  TheMovieDB
//
//  Created by Gabriel Hernández on 11/10/18.
//  Copyright © 2018 gabreho. All rights reserved.
//

import Foundation
import SwiftyJSON


public enum StatusCode: Int {
    case none = 0
    case ok = 200
    case created = 201
    case accepted = 202
    case noContent = 204
    case badRequest = 400
    case unauthorized = 401
    case notFound = 404
    case serverError = 500
    case networkLost = -1005
    
    var isSuccess: Bool {
        let raw: Int = self.rawValue
        return raw >= StatusCode.ok.rawValue && raw < StatusCode.badRequest.rawValue
    }
    
    var isFaulure: Bool {
        return !self.isSuccess
    }
}

public protocol APIResponseProtocol: class {
    init(with statusCode: StatusCode, json: JSON?)
}

class APIResponse: APIResponseProtocol {
    var statusCode: StatusCode
    var json: JSON?
    
    required init(with statusCode: StatusCode, json: JSON?) {
        self.json = json
        self.statusCode = statusCode
    }
}

class PagedResponse<T: MovieApiObject>: APIResponse {
    var page = 0
    var totalResults = 0
    var totalPages = 0
    var results: [T] = []
    
    required init(with statusCode: StatusCode, json: JSON?) {
        super.init(with: statusCode, json: json)
        if let json = json {
            self.page = json["page"].intValue
            self.totalPages = json["total_pages"].intValue
            self.totalResults = json["total_results"].intValue
            
            let resultsJson = json["results"].arrayValue
            
            for resultJson in resultsJson {
                self.results.append(T(with: resultJson))
            }
        }
    }
}
