//
//  MyMovieQuotesCollectionManager.swift
//  MovieQuotes
//
//  Created by Qijun Jiang on 2022/3/31.
//

import Foundation
import Firebase

class MovieQuotesCollectionManager{
    
    static let shared = MovieQuotesCollectionManager()
    var _collectionRef: CollectionReference
    var listenerRegistration: ListenerRegistration?
    
    private init(){
        _collectionRef = Firestore.firestore().collection(kMovieQuotesCollectionPath)
    }
    var latestMovieQuotes = [MovieQuote]()
    
    
    func startListening(FilterByAuthor authorFilter: String?, changeListener: @escaping (() -> Void) ) -> ListenerRegistration{
        //TODO: RECIEVE A changelistener
            
        
        var query = _collectionRef.order(by: kMovieQuoteLastTouched, descending: true).limit(to: 50)
        
        if let authorFilter = authorFilter {
            print("TODO: Filter by  this author \(authorFilter)")
            query = query.whereField(kMovieQuoteAuthorUid, isEqualTo: authorFilter)
        }
        
        return query.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.latestMovieQuotes.removeAll()
            for document in documents {
                //                print("\(document.documentID) => \(document.data())")
                self.latestMovieQuotes.append(MovieQuote(documentSnapshot: document))
            }
            changeListener()
        }
        
    }
    
    func stopListening(_ listenerRegistration: ListenerRegistration?){
        //IMPLEMENT
        print("remove the listener")
        listenerRegistration?.remove()
    }
    
    func add(_ mq:MovieQuote){
        var ref: DocumentReference? = nil
        ref = _collectionRef.addDocument(data: [kMovieQuoteQuote : mq.quote, kMovieQuoteMovie: mq.movie, kMovieQuoteLastTouched: Timestamp.init(),kMovieQuoteAuthorUid: AuthManager.shared.currentUser!.uid])
        {err in
            if let err = err {
                print("Error adding document \(err)")
            }else{
                print("Doucument added with id: \(ref!.documentID)")
            }
        }
    }
    
    func delete(_ documentId: String){
        _collectionRef.document(documentId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
}
