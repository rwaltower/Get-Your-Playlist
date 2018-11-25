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
    
    @IBOutlet weak var switchSearch: UISegmentedControl!
    
    var songs: [Song] = []
    var artists: [Artist] = []
    var genres: [Genre] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        switch switchSearch.selectedSegmentIndex
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
        
        switch switchSearch.selectedSegmentIndex
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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else {
            return
        }
        self.songs = []
        self.genres = []
        self.tableView.reloadData()
        activityIndicator?.startAnimating()
        
        switch switchSearch.selectedSegmentIndex
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
}

