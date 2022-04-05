//
//  MovieQuoteDocumentManager.swift
//  MovieQuotes
//
//  Created by Qijun Jiang on 2022/3/31.
//
import Firebase
import Foundation

class MovieQuotesDocumentManager{
    var latestMovieQuote : MovieQuote?
    
    static let shared = MovieQuotesDocumentManager()
    var _collectionRef: CollectionReference
    var listenerRegistration: ListenerRegistration?
    
    private init(){
        _collectionRef = Firestore.firestore().collection(kMovieQuotesCollectionPath)
    }
    
    
    func startListening(for documentId: String){
        //TODO: RECIEVE A changelistener
        
    }
    
    func stopListening(){
        //IMPLEMENT
        
    }
    
    func update(quote: String, movie:String){
        _collectionRef.document(latestMovieQuote!.documentId!).updateData([
            kMovieQuoteQuote: quote,
            kMovieQuoteMovie: movie,
            kMovieQuoteLastTouched: Timestamp.init()
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func startListening(for documentId: String, changeListener: @escaping (() -> Void) ) -> ListenerRegistration{
        //TODO: RECIEVE A changelistener
        let query = _collectionRef.document(documentId)
        return query.addSnapshotListener{ documentSnapshot, error in
            guard let document = documentSnapshot else {
              print("Error fetching document: \(error!)")
              return
            }
            guard let data = document.data() else {
              print("Document data was empty.")
              return
            }
//            print("Current data: \(data)")
            self.latestMovieQuote = MovieQuote(documentSnapshot: document)
            changeListener()
          }
    }
    
    func stopListening(_ listenerRegistration: ListenerRegistration?){
        //IMPLEMENT
        print("remove the listener")
        listenerRegistration?.remove()
    }
    
}
