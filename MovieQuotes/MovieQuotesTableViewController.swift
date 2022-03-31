//
//  MovieQuotesTableViewController.swift
//  MovieQuotes
//
//  Created by Qijun Jiang on 2022/3/28.
//

import UIKit

class MovieQuoteTableViewCell: UITableViewCell{             //use UITableViewCell here
    
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var movieLabel: UILabel!
    
    
}



class MovieQuotesTableViewController: UITableViewController {

    let kMovieQuoteCell = "MovieQuoteCell"//1. add constant for MovieQuoteCell identifier
//    let names = ["Dave", "Kristy", "Mckinley", "Keegan", "Bowen", "Neale"]//3. add array of names
    let kmovieQuoteDetailSegue = "movieQuoteDetailSegue"
    var movieQuotes = [MovieQuote]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddQuoteDialog))

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        let mq1 = MovieQuote(quote: "I'll be back", movie: "The terminator")
        let mq2 = MovieQuote(quote: "I'll be back", movie: "The terminator?")
        let mq3 = MovieQuote(quote: "Hello, my name is ", movie: "The terminator!")
        let mq4 = MovieQuote(quote: "I'll be back", movie: "The terminator<>")
        movieQuotes.append(mq1)
        movieQuotes.append(mq2)
        movieQuotes.append(mq3)
        movieQuotes.append(mq4)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MovieQuotesCollectionManager.shared.startListening{
            print("the movie quotes were updated")
            for mq in MovieQuotesCollectionManager.shared.latestMovieQuotes{
                print("\(mq.quote) in \(mq.movie)")
            }
        }
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MovieQuotesCollectionManager.shared.stopListening()
//        tableView.reloadData()
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
            self.movieQuotes.insert(mq, at:0)
            self.tableView.reloadData()
            
            
        }
        alertController.addAction(createQuoteAction)
        
        
        present(alertController, animated: true)
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
        return movieQuotes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kMovieQuoteCell, for: indexPath) as! MovieQuoteTableViewCell//2. change identifier

//         Configure the cell...
//        cell.textLabel?.text = "This is row \(indexPath.section)"//3. add text label. Not necessary to use section here
//        cell.textLabel?.text = "\(movieQuotes[indexPath.row].quote)"//print all names
//        cell.detailTextLabel?.text = "\(movieQuotes[indexPath.row].movie)"
        cell.quoteLabel.text = movieQuotes[indexPath.row].quote
        cell.movieLabel.text = movieQuotes[indexPath.row].movie
        return cell
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Todo: implement delete
            movieQuotes.remove(at: indexPath.row)
            tableView.reloadData()
            
        }
    }



    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kmovieQuoteDetailSegue{
            let mqdvc = segue.destination as! MovieQuoteDetailViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                mqdvc.movieQuote = movieQuotes[indexPath.row]
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
