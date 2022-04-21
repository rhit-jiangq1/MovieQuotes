//
//  SideMainViewController.swift
//  MovieQuotes
//
//  Created by Qijun Jiang on 2022/4/21.
//

import UIKit

class SideMainViewController: UIViewController {
    
    var tableViewController : MovieQuotesTableViewController{
        let navController = presentingViewController as! UINavigationController
        return navController.viewControllers.last as! MovieQuotesTableViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressedEditProfile(_ sender: Any) {
        dismiss(animated: true)
        tableViewController.performSegue(withIdentifier: kShowProfilePageSegue, sender: tableViewController)
    }
    
    @IBAction func pressedShowAllQuotes(_ sender: Any) {
        dismiss(animated: true)
        tableViewController.isShowingAllQuotes = true
        tableViewController.startListeningForMovieQuotes()
    }
    
    @IBAction func pressedShowMyQuotes(_ sender: Any) {
        dismiss(animated: true)
        tableViewController.isShowingAllQuotes = false
        tableViewController.startListeningForMovieQuotes()
    }
    
    @IBAction func pressedDeleteQuotes(_ sender: Any) {
        dismiss(animated: true)
        tableViewController.isEditing = !tableViewController.isEditing
    }
    
    @IBAction func pressedLogOut(_ sender: Any) {
        dismiss(animated: true) {
            AuthManager.shared.signOut()
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
