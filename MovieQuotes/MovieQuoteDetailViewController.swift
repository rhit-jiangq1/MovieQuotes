//
//  myMovieQuoteDetailViewController.swift
//  MovieQuotes
//
//  Created by Qijun Jiang on 2022/3/29.
//

import UIKit

class MovieQuoteDetailViewController: UIViewController {

    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var movieLabel: UILabel!
    
    var movieQuote: MovieQuote!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(showEditQuoteDialog))
        
        
        updateView()
        

    }
    
    //If the viewDidLoad crashes, it was too early, then I could do this
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        updateView()
//    }
    
    func updateView(){
        quoteLabel.text = movieQuote.quote
        movieLabel.text = movieQuote.movie
    }
    
    @objc func showEditQuoteDialog(){
        
        let alertController = UIAlertController(title: "Edit a new movie quote", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Quote"
            textField.text = self.movieQuote.quote
        }
        alertController.addTextField { textField in
            textField.placeholder = "Movie"
            textField.text = self.movieQuote.movie
        }
        
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { action in
            print("you pressed cancel")
        }
        alertController.addAction(cancelAction)
        
        
        
        let editQuoteAction = UIAlertAction(title: "Edit Quote", style: UIAlertAction.Style.default) { action in
            
            let quoteTextField = alertController.textFields![0] as UITextField
            let movieTextField = alertController.textFields![1] as UITextField
            print("Quote: \(quoteTextField.text!)")
            print("Movie: \(movieTextField.text!)")
            
            self.movieQuote.quote = quoteTextField.text!
            self.movieQuote.movie = movieTextField.text!
            self.updateView()
        }
        alertController.addAction(editQuoteAction)
        
        
        present(alertController, animated: true)
    }
}
