//
//  SearchViewController.swift
//  Get Your Playlist
//
//  Created by Radasia Waltower on 11/24/18.
//  Copyright © 2018 Team 6. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var pageContentViewController: PageContentViewController!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var lblTitle: UINavigationItem!
    @IBOutlet weak var choicesTable: UITableView!
    
    @IBOutlet weak var btnDone: UIBarButtonItem!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    
    var songs: [Song] = []
    var artists: [Artist] = []
    var genres: [Genre] = []
    
    var choices: [[String]] = []
    var artistNames: [String] = []
    var genreNames: [String] = []
    
    var searchTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        lblTitle.title = searchTitle
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch searchBar.selectedScopeButtonIndex
        {
        case 0:
            return artists.count
            
        case 1:
            return genres.count

        default:
            return 10
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        
        switch searchBar.selectedScopeButtonIndex
        {
        case 0:
            let artist = artists[indexPath.row]
            cell.textLabel?.text = artist.name
            
        case 1:
            let genre = genres[indexPath.row]
            cell.textLabel?.text = genre.name
        default:
            break
        }
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        let cellItem = cell!.textLabel?.text
        
        switch searchBar.selectedScopeButtonIndex
        {
        case 0:
            if artistNames.count == 3 {
                tableView.deselectRow(at: indexPath, animated: true)
                self.displayErrorMessage(message: "You can only choose 3 artists.")
            } else {
                artistNames.append(cellItem ?? "")
            }
        case 1:
            if genreNames.count == 3 {
                tableView.deselectRow(at: indexPath, animated: true)
                self.displayErrorMessage(message: "You can only choose 3 genres.")

            } else {
                genreNames.append(cellItem ?? "")

            }
            
        default:
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        let cellItem = cell!.textLabel?.text
        
        switch searchBar.selectedScopeButtonIndex
        {
        case 0:
            artistNames = artistNames.filter{$0 != cellItem }
            
        case 1:
            genreNames = genreNames.filter{$0 != cellItem }

        default:
            break
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchTerm = searchText
        self.artists = []
        self.genres = []
        
        self.tableView.reloadData()
        activityIndicator?.startAnimating()
        
        switch searchBar.selectedScopeButtonIndex
        {
        case 0:
            DataManager.sharedInstance.getArtistSearchResults(searchTerm: searchTerm, completion: {(data) in
                DispatchQueue.main.async {
                    if let result = data {
                        self.artists = result
                        self.tableView.reloadData()
                    } else {
                        //error
                    }
                    self.activityIndicator?.stopAnimating()
                }
            })
            
        case 1:
            DataManager.sharedInstance.getGenreSearchResults(searchTerm: searchTerm, completion: {(data) in
                DispatchQueue.main.async {
                    if let result = data {
                        
                        self.genres = result
                        self.tableView.reloadData()
                    } else {
                        //error
                    }
                    self.activityIndicator?.stopAnimating()
                }
            })
            
        default:
            break
        }
        
        
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        self.choices.append(artistNames)
        self.choices.append(genreNames)
        
        self.pageContentViewController.artistData = artistNames
        self.pageContentViewController.genreData = genreNames
        
        self.pageContentViewController.allData = self.pageContentViewController.artistData + self.pageContentViewController.genreData
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshTable"), object: nil)
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)

    }
    
    func displayErrorMessage(message:String) {
        let alertView = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion:nil)
    }
}

