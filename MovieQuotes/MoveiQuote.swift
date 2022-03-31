//
//  MoveiQuote.swift
//  MovieQuotes
//
//  Created by Qijun Jiang on 2022/3/28.
//

import Foundation

class MovieQuote{
    var quote: String
    var movie: String
    var documentId: String?
    
    init(quote: String, movie: String){
        self.quote = quote
        self.movie = movie
    }
}
