//
//  LoginViewController.swift
//  MovieQuotes
//
//  Created by Qijun Jiang on 2022/4/18.
//

import UIKit
import Firebase

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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
