//
//  UserDocumentManager.swift
//  MovieQuotes
//
//  Created by Qijun Jiang on 2022/4/25.
//

import Foundation
import Firebase

class UserDocumentManager{
    var _latestDocument: DocumentSnapshot?
    
    static let shared = UserDocumentManager()
    var _collectionRef: CollectionReference
    var listenerRegistration: ListenerRegistration?
    
    private init(){
        _collectionRef = Firestore.firestore().collection(kUsersCollectionPath)
    }
    
    
    func startListening(for documentId: String, changeListener: @escaping (() -> Void) ) -> ListenerRegistration{
        //TODO: RECIEVE A changelistener
        let query = _collectionRef.document(documentId)
        return query.addSnapshotListener{ documentSnapshot, error in
            self._latestDocument = nil
            guard let document = documentSnapshot else {
              print("Error fetching document: \(error!)")
              return
            }
            guard document.data() != nil else {
              print("Document data was empty.")
              return
            }
            self._latestDocument = document
            changeListener()
          }
    }
    
    func stopListening(_ listenerRegistration: ListenerRegistration?){
        print("remove the listener")
        listenerRegistration?.remove()
    }
    
    var name: String{
        if let name = _latestDocument?.get(kUserName) {
            return name as! String
        }
        return ""
    }
    
    var photoUrl: String{
        if let photoUrl = _latestDocument?.get(kUserPhotoUrl){
            return photoUrl as! String
        }
        return ""
    }
    
    func updateName(name: String){
        _collectionRef.document(_latestDocument!.documentID).updateData([
            kUserName: name,
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func updateUrl(photoUrl: String){
        _collectionRef.document(_latestDocument!.documentID).updateData([
            kUserPhotoUrl: photoUrl,
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    
}
