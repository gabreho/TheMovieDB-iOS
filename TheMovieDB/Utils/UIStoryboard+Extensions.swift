//
//  UIStoryboard+Extensions.swift
//  TheMovieDB
//
//  Created by Gabriel Hernández on 11/10/18.
//  Copyright © 2018 gabreho. All rights reserved.
//

import UIKit

@objc extension UIStoryboard {
    
    static let main: UIStoryboard = {
        return UIStoryboard(name: "Main", bundle: nil)
    }()
}
