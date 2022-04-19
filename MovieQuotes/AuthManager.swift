//
//  AuthManager.swift
//  MovieQuotes
//
//  Created by Qijun Jiang on 2022/4/7.
//

import Foundation
import Firebase

class AuthManager{
    
    static let shared = AuthManager()
    private init(){
        
    }
    
    var currentUser: User? {
        Auth.auth().currentUser
    }
    
    var isSignedIn: Bool{
        return currentUser != nil
    }
    
    
    func addLoginOvserver(callback:@escaping(() -> Void)) -> AuthStateDidChangeListenerHandle{
        return Auth.auth().addStateDidChangeListener { auth, user in
            if(user != nil){
                callback()
            }
        }
    }
    
    func addLogoutOvserver(callback:@escaping(() -> Void)) -> AuthStateDidChangeListenerHandle{
        return Auth.auth().addStateDidChangeListener { auth, user in
            if(user == nil){
                callback()
            }
        }
    }
    
    func removeObserver(_ authDidChangeHandle: AuthStateDidChangeListenerHandle?){
        if let authHandle = authDidChangeHandle{
            Auth.auth().removeStateDidChangeListener(authHandle)
        }
    }
    
    func signInNewEmailPasswordUser(email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password){authResult, error in
            if let error = error{
                print("There was an error creating the user: \(error)")
                return
            }
            print("User created")
        }
    }
    
    func loginExistingEmailPasswordUser(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password){authResult, error in
            if let error = error{
                print("User already signed in: \(error)")
                return
            }
            print("User created")
        }
    }
    
    func signInAnonymously(){
        Auth.auth().signInAnonymously(completion: { authResult, error in
            if let error = error{
                print("There was an error anonymous user: \(error)")
                return
            }
            print("Sign in anonymously")
        })
    }
    
    func signInWithRosefireToken(_ rosefireToken: String){
        Auth.auth().signIn(withCustomToken: rosefireToken) { (authResult, error) in
            if let error = error {
                print("Firebase sign in error! \(error)")
                return
            }
            print("The user is now actually signed in using the Rosefire token")
            // User is signed in using Firebase!
        }
    }
        
        
        func signOut(){
            do {
                try Auth.auth().signOut()
            }catch{
                print("Sign out failed: \(error)")
            }
            
        }
        
    }
