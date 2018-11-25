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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var lblTitle: UINavigationItem!
    
    @IBOutlet weak var btnDone: UIBarButtonItem!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    
    var songs: [Song] = []
    var artists: [Artist] = []
    var genres: [Genre] = []
    
    var choices: [[String]] = []
    var artistChoices: [String] = []
    var genreChoices: [String] = []
    
    var searchTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        choices.append(artistChoices)
        choices.append(genreChoices)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
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
            choices[0].append(cellItem ?? "")
            
        case 1:
            choices[1].append(cellItem ?? "")
            
        default:
            break
        }
        
        print(choices)
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        let cellItem = cell!.textLabel?.text
        
        switch searchBar.selectedScopeButtonIndex
        {
        case 0:
            choices[0] = choices[0].filter{$0 != cellItem }
            
        case 1:
            choices[1] = choices[1].filter{$0 != cellItem }

        default:
            break
        }
        
        print(choices)

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
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)

    }
}

