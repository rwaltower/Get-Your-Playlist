//
//  HomeViewController.swift
//  Get Your Playlist
//
//  Created by Radasia Waltower on 11/20/18.
//  Copyright © 2018 Team 6. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController {
    
    @IBOutlet weak var btnCreatePlaylist: UIButton!
    @IBOutlet weak var playlistsTable: UITableView!
    @IBOutlet weak var btnLogout: UIButton!
    
    @IBOutlet weak var btnPersonalization: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self.view, action: #selector(UIView.endEditing(_:))))
        
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func createPlaylistButtonPressed(_ sender: UIButton) {
        let createPlaylistViewController = self.storyboard?.instantiateViewController(withIdentifier: "CreatePlaylistViewController") as! CreatePlaylistViewController
        self.present(createPlaylistViewController, animated: true, completion: nil)
    }
    
    @IBAction func personalizationButtonPressed(_ sender: UIButton) {
        let personalizationViewController = self.storyboard?.instantiateViewController(withIdentifier: "PersonalizationViewController") as! PersonalizationViewController
        self.present(personalizationViewController, animated: true, completion: nil)
    }
    @IBAction func logout(_ sender: UIButton) {
        PFUser.logOut()
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
}

