//
//  LoginViewController.swift
//  MovieQuotes
//
//  Created by Qijun Jiang on 2022/4/18.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    var loginHandle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EmailTextField.placeholder = "Email"
        PasswordTextField.placeholder = "Password"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginHandle = AuthManager.shared.addLoginOvserver {
            print("TODO: fire the showListSeguue. THere is already someone signed in")
            self.performSegue(withIdentifier: kShowListSegue, sender: self)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AuthManager.shared.removeObserver(loginHandle)
    }
    
    @IBAction func PressedCreateNewUser(_ sender: Any) {
        
        let email = EmailTextField.text!
        let password = PasswordTextField.text!
        
        print("Pressed CREATE NEW User Email: \(email), Password: \(password)")
        
        AuthManager.shared.signInNewEmailPasswordUser(email: email, password: password)
    }
    
    @IBAction func PressedLoginExistingUser(_ sender: Any) {
        let email = EmailTextField.text!
        let password = PasswordTextField.text!
        
        print("Pressed Login Existing User Email: \(email), Password: \(password)")
        
        AuthManager.shared.loginExistingEmailPasswordUser(email: email, password: password)
    }
    
    
    @IBAction func pressedRoseFire(_ sender: Any) {
        print("Todo: using RoseFire")
        
        Rosefire.sharedDelegate().uiDelegate = self // This should be your view controller
        Rosefire.sharedDelegate().signIn(registryToken: kRosefireRegistryToken) { (err, result) in
            if let err = err {
                print("Rosefire sign in error! \(err)")
                return
            }
            //          print("Result = \(result!.token!)")
            //          print("Result = \(result!.username!)")
            print("Rosefire worked. Name = \(result!.name!)")
            //          print("Result = \(result!.email!)")
            //          print("Result = \(result!.group!)")
            //
            //          }
            AuthManager.shared.signInWithRosefireToken(result!.token)
        }
        
    }
    
    @IBAction func pressedGoogleSignIn(_ sender: Any) {
        print("Sign in with Google")
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
            
            if let error = error {
                // ...
                print("error with Google SignIn \(error)")
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            print("Google sign in worked! Now use the credential to do the real Firebase sign in")
            AuthManager.shared.signInWithGoogleCredential(credential)
            // ...
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
