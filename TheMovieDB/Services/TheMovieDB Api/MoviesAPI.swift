//
//  MoviesAPI.swift
//  TheMovieDB
//
//  Created by Gabriel Hernández on 11/10/18.
//  Copyright © 2018 gabreho. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

public struct MoviesAPI {
    
    static var url = "https://api.themoviedb.org/3/"
    static var apiKey = ""
    
    fileprivate static var manager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        return SessionManager(configuration: configuration)
    }()
    
    static func imageUrl(with imagePath: String, imageSize: String = "w500") -> String {
        return "http://image.tmdb.org/t/p/".appendingPathComponent(path: imageSize).appendingPathComponent(path:imagePath)
    }
}


protocol APIEndpoint {
    var endpoint: String { get }
    var method: String { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String] { get }
    
    associatedtype APIResponseType: APIResponseProtocol
    typealias APICallback = (APIResponseType?) -> Void
}

extension APIEndpoint {
    
    func request(_ completion: APICallback?) {
        _sendRequest(completion)
    }
    
    var parameters: [String : Any]? {
        return nil
    }
    
    var headers: [String: String] {
        return [:]
    }
    
    func endpointUrl() -> String {
        let url = MoviesAPI.url.appendingPathComponent(path: endpoint)
        return url
    }
    
    internal func _sendRequest(_ completion: APICallback? = nil) {
        let _method = method
        let _endpointUrl = endpointUrl()
        let _headers: HTTPHeaders = headers
        var _parameters = parameters ?? [:]
        
        _parameters["api_key"] = MoviesAPI.apiKey
        
        let httpMethod = HTTPMethod(rawValue: _method) ?? HTTPMethod.get
        MoviesAPI.manager.request(_endpointUrl, method: httpMethod, parameters: _parameters, headers: _headers).responseJSON {
            
            var json: JSON?
            if let responseVal = $0.result.value {
                json = JSON(responseVal)
            }
            var statusCode: StatusCode = .none
            if let httpResponse = $0.response, let status = StatusCode(rawValue: httpResponse.statusCode) {
                statusCode = status
            }
            
            if let completion = completion {
                let response = APIResponseType(with: statusCode, json: json)
                completion(response)
            }
        }
    }
}
