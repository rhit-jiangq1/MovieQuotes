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
    
    func addNewUserMaybe(uid:String, name:String?, photoUrl:String?){
        // *GET* the user document for this uid
        //if it ialready exists do nothing
        //there is no user document, make it using the name and photourl.
        let docRef = _collectionRef.document(uid)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                print("Document existing, do nothing. Here is the data: \(document.data()!)")
            } else {
                print("Document does not exist, create this user")
                docRef.setData([kUserName:name ?? "", kUserPhotoUrl:photoUrl ?? ""])
            }
        }
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
