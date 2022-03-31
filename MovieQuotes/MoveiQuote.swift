//
//  MoveiQuote.swift
//  MovieQuotes
//
//  Created by Qijun Jiang on 2022/3/28.
//

import Foundation
import Firebase

class MovieQuote{
    var quote: String
    var movie: String
    var documentId: String?
    
    init(quote: String, movie: String){
        self.quote = quote
        self.movie = movie
    }
    
    init(documentSnapshot: DocumentSnapshot){
        self.documentId = documentSnapshot.documentID
        let data = documentSnapshot.data()
        self.quote = data?[kMovieQuoteQuote] as? String ?? ""
        self.movie = data?[kMovieQuoteMovie] as? String ?? ""
        self.documentId = documentSnapshot.documentID
    }
}
