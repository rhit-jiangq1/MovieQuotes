//
//  myMovieQuoteDetailViewController.swift
//  MovieQuotes
//
//  Created by Qijun Jiang on 2022/3/29.
//

import UIKit
import Firebase

class MovieQuoteDetailViewController: UIViewController {
    
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var movieLabel: UILabel!
    
    @IBOutlet weak var AuthorBoxStackView: UIStackView!
    @IBOutlet weak var AuthorProfileImageView: UIImageView!
    @IBOutlet weak var AuthorNameLabel: UILabel!
    
    
    
    //    var movieQuote: MovieQuote!
    var movieQuoteDocumentId: String!
    
    var movieQuoteListenerRegistration: ListenerRegistration?
    var userListenerRegistration: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        updateView()
    }
    
    func showOrHideEditButton(){
        if(AuthManager.shared.currentUser?.uid == MovieQuotesDocumentManager.shared.latestMovieQuote?.authorUid){
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                                     target: self,
                                                                     action: #selector(showEditQuoteDialog))
        }else{
            print("this is not your quote, don't allow edit")
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    //If the viewDidLoad crashes, it was too early, then I could do this
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movieQuoteListenerRegistration = MovieQuotesDocumentManager.shared.startListening(for: movieQuoteDocumentId!){
            print("Todo: update the view")
            self.updateView()
            self.showOrHideEditButton()
            
            //Start listening for the User (Author of data)
            self.AuthorBoxStackView.isHidden = true
            if let authorUid = MovieQuotesDocumentManager.shared.latestMovieQuote!.authorUid{
                UserDocumentManager.shared.stopListening(self.userListenerRegistration)
                self.userListenerRegistration = UserDocumentManager.shared.startListening(for: authorUid){
                    //                    self.updateView()
                    self.updateAuthorBox()
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MovieQuotesDocumentManager.shared.stopListening(movieQuoteListenerRegistration)
    }
    
    
    func updateView(){
        if let mq = MovieQuotesDocumentManager.shared.latestMovieQuote{
            quoteLabel.text = mq.quote
            movieLabel.text = mq.movie
        }
    }
    
    func updateAuthorBox(){
        print("TODO: update the author box with name: \(UserDocumentManager.shared.name)")
        print("TODO: update the author box with photoURL: \(UserDocumentManager.shared.photoUrl)")
        
        self.AuthorBoxStackView.isHidden = (UserDocumentManager.shared.name.isEmpty)&&(UserDocumentManager.shared.photoUrl.isEmpty)
        AuthorNameLabel.text = UserDocumentManager.shared.name
        
        if !UserDocumentManager.shared.photoUrl.isEmpty{
            ImageUtils.load(imageView: AuthorProfileImageView, from: UserDocumentManager.shared.photoUrl)
        }
    }
    
    
    @objc func showEditQuoteDialog(){
        
        let alertController = UIAlertController(title: "Edit a new movie quote", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Quote"
            textField.text = MovieQuotesDocumentManager.shared.latestMovieQuote?.quote
            
            //TODO: uput in the quote data using the manager's data
        }
        alertController.addTextField { textField in
            textField.placeholder = "Movie"
            //            textField.text = self.movieQuote.movie
            textField.text = MovieQuotesDocumentManager.shared.latestMovieQuote?.movie
            
            //TODO: put in the movie data using the manager's data
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
            
            MovieQuotesDocumentManager.shared.update(quote:quoteTextField.text!,movie:movieTextField.text!)
            
            //            self.movieQuote.quote = quoteTextField.text!
            //            self.movieQuote.movie = movieTextField.text!
            self.updateView()
        }
        alertController.addAction(editQuoteAction)
        
        
        present(alertController, animated: true)
    }
}
