//
//  MovieQuotesTableViewController.swift
//  MovieQuotes
//
//  Created by Qijun Jiang on 2022/3/28.
//

import UIKit
import Firebase

class MovieQuoteTableViewCell: UITableViewCell{             //use UITableViewCell here
    
    @IBOutlet weak var quoteLabel: UILabel!
    
    @IBOutlet weak var movieLabel: UILabel!
    
    
}



class MovieQuotesTableViewController: UITableViewController {
    
    let kMovieQuoteCell = "MovieQuoteCell"//1. add constant for MovieQuoteCell identifier
    //    let names = ["Dave", "Kristy", "Mckinley", "Keegan", "Bowen", "Neale"]//3. add array of names
    let kmovieQuoteDetailSegue = "movieQuoteDetailSegue"
    var movieQuotesListenerRegistration: ListenerRegistration?
    //    var movieQuotes = [MovieQuote]()
    var isShowingAllQuotes = true
    var logoutHandle: AuthStateDidChangeListenerHandle?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        //        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddQuoteDialog))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "☰", style: .plain, target: self, action: #selector(showMenu))
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        //        let mq1 = MovieQuote(quote: "I'll be back", movie: "The terminator")
        //        let mq2 = MovieQuote(quote: "I'll be back", movie: "The terminator?")
        //        let mq3 = MovieQuote(quote: "Hello, my name is ", movie: "The terminator!")
        //        let mq4 = MovieQuote(quote: "I'll be back", movie: "The terminator<>")
        //        movieQuotes.append(mq1)
        //        movieQuotes.append(mq2)
        //        movieQuotes.append(mq3)
        //        movieQuotes.append(mq4)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startListeningForMovieQuotes()
        //        movieQuotesListenerRegistration = MovieQuotesCollectionManager.shared.startListening{
        //            print("the movie quotes were updated")
        //            for mq in MovieQuotesCollectionManager.shared.latestMovieQuotes{
        //                print("\(mq.quote) in \(mq.movie)")
        //            }
        //            self.tableView.reloadData()
        //            print("update the table due to new data")
        //
        //            //TODO: Eventually use real login, but for now user Guest mode
        //            if(AuthManager.shared.isSignedIn) {
        //                print("User is already signed in")
        //            } else {
        //                print("No user, so singing in anonymously")
        //                AuthManager.shared.signInAnonymously()
        //            }
        //        }
//        if(!AuthManager.shared.isSignedIn) {
//            print("U got to this page without a user")
//            navigationController?.popViewController(animated: true)
//        }
//        } else {
//            print("No user, so singing in anonymously")
//            AuthManager.shared.signInAnonymously()
//        }
        logoutHandle = AuthManager.shared.addLogoutOvserver {
            print("Someone sign out, go back to the login view controller")
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MovieQuotesCollectionManager.shared.stopListening(movieQuotesListenerRegistration)
        //        tableView.reloadData()
        AuthManager.shared.removeObserver(logoutHandle)
    }
    
    func startListeningForMovieQuotes(){
        stopListeningForMovieQuotes()   //This will do nothing first time, but will be useful later
        movieQuotesListenerRegistration = MovieQuotesCollectionManager.shared.startListening(FilterByAuthor: isShowingAllQuotes ? nil : AuthManager.shared.currentUser?.uid){
            self.tableView.reloadData()
        }
    }
    
    func stopListeningForMovieQuotes(){
        
    }
    
    @objc func showAddQuoteDialog(){
        
        let alertController = UIAlertController(title: "Create a new movie quote", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Quote"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Movie"
        }
        
        
        
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { action in
            print("you pressed cancel")
        }
        alertController.addAction(cancelAction)
        
        
        
        let createQuoteAction = UIAlertAction(title: "Create Quote", style: UIAlertAction.Style.default) { action in
            print("you pressed create quote")
            
            let quoteTextField = alertController.textFields![0] as UITextField
            let movieTextField = alertController.textFields![1] as UITextField
            print("Quote: \(quoteTextField.text!)")
            print("Movie: \(movieTextField.text!)")
            
            let mq = MovieQuote(quote: quoteTextField.text!, movie: movieTextField.text!)
            //            self.movieQuotes.append(mq)
            //            self.movieQuotes.insert(mq, at:0)
            //            self.tableView.reloadData()
            
            //TODO: figure out if this actually works
            MovieQuotesCollectionManager.shared.add(mq)
        }
        alertController.addAction(createQuoteAction)
        
        
        present(alertController, animated: true)
    }
    
    @objc func showMenu(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let  showOnlyMyQuotes = UIAlertAction(title: isShowingAllQuotes ? "Show only my quotes" : "Show all quotes", style: UIAlertAction.Style.default) { action in
            print("you pressed SHOW MY QUOTE")
            self.isShowingAllQuotes = !self.isShowingAllQuotes
            self.startListeningForMovieQuotes()
        }
        alertController.addAction(showOnlyMyQuotes)
        
        //        let  showAllQuotes = UIAlertAction(title: "Show all quotes", style: UIAlertAction.Style.default) { action in
        //            print("you pressed Show all quotes")
        //        }
        //        alertController.addAction(showAllQuotes)
        
        let  AddAQuote = UIAlertAction(title: "Add a quote", style: UIAlertAction.Style.default) { action in
            //            print("you pressed add a quote")
            self.showAddQuoteDialog()
        }
        alertController.addAction(AddAQuote)
        
        let  signOut = UIAlertAction(title: "Sign Out", style: UIAlertAction.Style.default) { action in
            //            print("you pressed sign out")
            AuthManager.shared.signOut()
        }
        alertController.addAction(signOut)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { action in
            print("you pressed cancel")
        }
        alertController.addAction(cancelAction)
        
        present(alertController,animated: true)
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        <#code#>
    //    }
    //    //willAppear<-->didDisappear, didAppear<-->willDisappear
    //    override func viewDidDisappear(_ animated: Bool) {
    //        <#code#>
    //    }
    
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 1
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return self.names.count
        //        return movieQuotes.count
        return MovieQuotesCollectionManager.shared.latestMovieQuotes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kMovieQuoteCell, for: indexPath) as! MovieQuoteTableViewCell//2. change identifier
        
        //         Configure the cell...
        //        cell.textLabel?.text = "This is row \(indexPath.section)"//3. add text label. Not necessary to use section here
        //        cell.textLabel?.text = "\(movieQuotes[indexPath.row].quote)"//print all names
        //        cell.detailTextLabel?.text = "\(movieQuotes[indexPath.row].movie)"
        
        //        cell.quoteLabel.text = movieQuotes[indexPath.row].quote
        //        cell.movieLabel.text = movieQuotes[indexPath.row].movie
        
        let mq = MovieQuotesCollectionManager.shared.latestMovieQuotes[indexPath.row]
        cell.quoteLabel.text = mq.quote
        cell.movieLabel.text = mq.movie
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        let mq = MovieQuotesCollectionManager.shared.latestMovieQuotes[indexPath.row]
        return AuthManager.shared.currentUser?.uid == mq.authorUid
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Todo: implement delete
            //            movieQuotes.remove(at: indexPath.row)
            //            tableView.reloadData()
            
            let mqToDelete = MovieQuotesCollectionManager.shared.latestMovieQuotes[indexPath.row]
            
            MovieQuotesCollectionManager.shared.delete(mqToDelete.documentId!)
            
        }
    }
    
    
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kmovieQuoteDetailSegue{
            let mqdvc = segue.destination as! MovieQuoteDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                //                mqdvc.movieQuote = movieQuotes[indexPath.row]
                let mq = MovieQuotesCollectionManager.shared.latestMovieQuotes[indexPath.row]
                mqdvc.movieQuoteDocumentId = mq.documentId
                
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
}
