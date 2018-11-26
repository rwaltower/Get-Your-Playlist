//
//  CreatePlaylistViewController.swift
//  Get Your Playlist
//
//  Created by Radasia Waltower on 11/25/18.
//  Copyright © 2018 Team 6. All rights reserved.
//

import Foundation
import UIKit

class CreatePlaylistViewControllers: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
    let appleMusicManager = AppleMusicManager()
    
    var moodPicker: UIPickerView! = nil
    var activityPicker: UIPickerView! = nil
    var durationPicker: UIPickerView! = nil
    
    var moodNames: [String] = []
    var activityNames: [String] = []
    var durationAmounts: [Int] = [15, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120]
    
    @IBOutlet weak var txtPlaylistName: UITextField!
    @IBOutlet weak var txtMood: UITextField!
    @IBOutlet weak var txtActivity: UITextField!
    @IBOutlet weak var txtDuration: UITextField!
    @IBOutlet weak var btnCreate: UIBarButtonItem!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    
    
    var chosenMood: String = ""
    var chosenActivity: String = ""
    var chosenDuration: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func createPlaylist() {
        
        var data: [String] = []
        var songNames: [String] = []
        var songDurations: [Int] = []
        
        retrieveSongs(terms: data, completion: { (songArray) in
            for song in songArray! {
                songNames.append(song.name)
                songDurations.append(song.duration)
            }
            
            
        })
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == moodPicker {
            return moodNames.count
        }
        if pickerView == activityPicker {
            return activityNames.count
        }
        if pickerView == durationPicker {
            return durationAmounts.count
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
            return String(durationAmounts[row])
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
    }
    
    @IBAction func cancelCreatePlaylist(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func chooseMood(_ sender: UITextField) {
    }
    
    @IBAction func chooseActivity(_ sender: UITextField) {
    }
    
    @IBAction func chooseDuration(_ sender: UITextField) {
    }
}
