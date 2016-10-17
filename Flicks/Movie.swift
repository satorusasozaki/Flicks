//
//  Movie.swift
//  Flicks
//
//  Created by Satoru Sasozaki on 10/17/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import Foundation

class Movie : NSObject {
    var movie : NSDictionary
    var title : String?
    var overview : String?
    var imageUrl : URL?
    static var baseUrl: String = "http://image.tmdb.org/t/p/w500"
    
    init(fromDictionary movie : NSDictionary) {
        self.movie = movie
        title = movie["title"] as? String
        overview = movie["overview"] as? String
        if let posterPath = movie["poster_path"] as? String {
            imageUrl = URL(string: Movie.baseUrl + posterPath)
        } else {
            imageUrl = nil
        }
        super.init()
    }
    
    convenience override init() {
        let dictionaryForInitialization = NSDictionary()
        self.init(fromDictionary: dictionaryForInitialization)
    }
}
