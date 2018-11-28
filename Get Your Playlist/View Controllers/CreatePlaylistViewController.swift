//
//  CreatePlaylistViewController.swift
//  Get Your Playlist
//
//  Created by Radasia Waltower on 11/25/18.
//  Copyright © 2018 Team 6. All rights reserved.
//

import Foundation
import UIKit
import Parse

class CreatePlaylistViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let currentUser = PFUser.current()
    
    let appleMusicManager = AppleMusicManager()
    
    let playlistManager = PlaylistManager()
    
    var mediaLibraryManager: MediaLibraryManager!

    
    let moodPicker = UIPickerView()
    let activityPicker = UIPickerView()
    let durationPicker = UIPickerView()
    
    var moodNames: [String] = []
    var activityNames: [String] = []
    var durationAmounts: [Int] = [15, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120]
    
    var chosenSongs: [[String]] = []
    
    @IBOutlet weak var txtPlaylistName: UITextField!
    @IBOutlet weak var txtMood: UITextField!
    @IBOutlet weak var txtActivity: UITextField!
    @IBOutlet weak var txtDuration: UITextField!
    
    @IBOutlet weak var btnCreate: UIBarButtonItem!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self.view, action: #selector(UIView.endEditing(_:))))
        PersonaliaztionManager.personalizationManager.getPersonalizationPageTitles(completion: {(titles, moods, activities) in
            
            for mood in moods {
                self.moodNames.append(mood["name"] as! String)
            }
            
            for activity in activities {
                self.activityNames.append(activity["name"] as! String)
            }
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshMediaItems() -> Void {

    }
    
    func chooseSongs(_ songData: [[Any]], playlistDuration: Int) -> [[String]] {
        var songs: [[String]] = []
        
        var totalDuration: Int = 0
        
        let playlistDurationInMillis = playlistDuration * 60000
        
        while totalDuration < playlistDurationInMillis {
            for song in songData {
                
                totalDuration += song[1] as! Int
                songs[0].append(song[0] as! String)
                songs[2].append(song[2] as! String)
            }
        }
        
        
        
        print(songs)
        return songs
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == durationPicker {
            return 2
        } else {
        return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == moodPicker {
            return moodNames.count
        }
        if pickerView == activityPicker {
            return activityNames.count
        }
        if pickerView == durationPicker {
            if component == 1 {
                return 1
            } else {
            return durationAmounts.count
            }
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == moodPicker {
            return moodNames[row]
        }
        if pickerView == activityPicker {
            return activityNames[row]
        }
        if pickerView == durationPicker {
            if component == 1 {
                return "minutes"
            } else {
            return String(durationAmounts[row])
            }
        } else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == moodPicker {
            txtMood.text = moodNames[row]
        }
        if pickerView == activityPicker {
            txtActivity.text = activityNames[row]
        }
        if pickerView == durationPicker {
            txtDuration.text = String(durationAmounts[row])
        }
    }
    
    
    
    func retrieveSongs(terms: [String], completion: @escaping (_ songArray: [MediaItem]? ) -> ()) {
        
        var mediaItems = [MediaItem]()
        
        for term in terms {
            appleMusicManager.performAppleMusicCatalogSearch(with: term,
                                                             completion: { [weak self] (searchResults, error) in
                                                                guard error == nil else {
                                                                    
                                                                    // Your application should handle these errors appropriately depending on the kind of error.
                                                                    mediaItems = []
                                                                    
                                                                    let alertController: UIAlertController
                                                                    
                                                                    guard let error = error as NSError?, let underlyingError = error.userInfo[NSUnderlyingErrorKey] as? Error else {
                                                                        
                                                                        alertController = UIAlertController(title: "Error",
                                                                                                            message: "Encountered unexpected error.",
                                                                                                            preferredStyle: .alert)
                                                                        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                                                                        
                                                                        DispatchQueue.main.async {
                                                                            self?.present(alertController, animated: true, completion: nil)
                                                                        }
                                                                        
                                                                        return
                                                                    }
                                                                    
                                                                    alertController = UIAlertController(title: "Error",
                                                                                                        message: underlyingError.localizedDescription,
                                                                                                        preferredStyle: .alert)
                                                                    alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                                                                    
                                                                    DispatchQueue.main.async {
                                                                        self?.present(alertController, animated: true, completion: nil)
                                                                    }
                                                                    
                                                                    return
                                                                }
                                                                
                                                                mediaItems += searchResults
                                                               
            })
        }
        
        completion(mediaItems)
        
    }
    
    @IBAction func createPlaylist(_ sender: UIBarButtonItem) {
        var data: [String] = []
        var songNames: [String] = []
        var songDurations: [Int] = []
        var songsIds: [String] = []
        
        let mood = txtMood.text
        let activity = txtActivity.text
        let duration = Int(txtDuration.text!)
        
        playlistManager.retrieveMoodData(myMood: mood!, completion: { (moodArray) in
            data = moodArray!
            
            if moodArray?.count == 0 {
                let dataAlert = UIAlertController(title: "Error", message: "You don't have enough data to create this playlist. Try taking the Personalization Quiz again.", preferredStyle: .alert)
                dataAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(dataAlert, animated: true)
                
            } else {
            
                self.playlistManager.retrieveActivityData(myActivity: activity!, completion: { (activityArray) in
                    data += activityArray!
                    var noDuplicateIds: [String] = []
                    var noDuplicates: [MediaItem] = []
                    self.retrieveSongs(terms: data, completion: { (songArray) in
                        for song in songArray! {
                            if !noDuplicateIds.contains(song.identifier) {
                                noDuplicateIds.append(song.identifier)
                                noDuplicates.append(song)
                            }
                        }
                        var songData: [[Any]] = []
                        let shuffledSongs = noDuplicates.shuffled()
                        for song in shuffledSongs {
                            songNames.append(song.name)
                            songDurations.append(song.duration)
                            songsIds.append(song.identifier)
                        }
                        
                        songData.append(songNames)
                        songData.append(songDurations)
                        songData.append(songsIds)
                        
                        self.chosenSongs = self.chooseSongs(songData, playlistDuration: duration!)
                        
                        let chosenSongIds: [String] = self.chosenSongs[2]
                        
                        let playlist = self.playlistManager.createPlaylist(data: chosenSongIds, playlistName: self.txtPlaylistName.text!)
                        
                        var newPlaylist = PFObject(className: "Playlist")
                        newPlaylist["title"] = self.txtPlaylistName.text!
                        newPlaylist["songs"] = chosenSongIds
                        newPlaylist["uuid"] = playlist
                        newPlaylist.saveInBackground { (success: Bool, error: Error?) in
                            if (success) {
                                var userPlaylist = PFObject(className: "user_has_playlists")
                                userPlaylist["user_id"] = self.currentUser
                                userPlaylist["playlist_id"] = userPlaylist
                            } else {
                                // There was a problem, check error.description
                            }
                        }
                        
                        
                    })
                })
            }
            
        })
        
        
        
        
    }
    
    @IBAction func cancelCreatePlaylist(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func chooseMood(_ sender: UITextField) {
        moodPicker.dataSource = self
        moodPicker.delegate = self
        txtMood.inputView = moodPicker
    }
    
    @IBAction func chooseActivity(_ sender: UITextField) {
        activityPicker.dataSource = self
        activityPicker.delegate = self
        txtActivity.inputView = activityPicker
    }
    
    @IBAction func chooseDuration(_ sender: UITextField) {
        durationPicker.dataSource = self
        durationPicker.delegate = self
        txtDuration.inputView = durationPicker
    }
}
