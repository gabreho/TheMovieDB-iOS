//
//  String+Extensions.swift
//  TheMovieDB
//
//  Created by Gabriel Hernández on 11/10/18.
//  Copyright © 2018 gabreho. All rights reserved.
//

import Foundation

extension String {
    func appendingPathComponent(path: String) -> String {
        var newString = self
        if !self.hasSuffix("/") {
            newString = newString + "/"
        }
        
        var aPath = path
        if aPath.hasPrefix("/") {
            aPath.remove(at: aPath.startIndex)
        }
        newString = newString + aPath
        return newString
    }
}
