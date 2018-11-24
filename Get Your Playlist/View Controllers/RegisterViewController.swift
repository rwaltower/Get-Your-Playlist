//
//  RegisterViewController.swift
//  Get Your Playlist
//
//  Created by Radasia Waltower on 11/20/18.
//  Copyright © 2018 Team 6. All rights reserved.
//

import UIKit
import Parse

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    @IBOutlet weak var btnSubmit: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonPressed(_ sneder: UIBarButtonItem) {
        if(txtFirstName.text?.isEmpty)! || (txtLastName.text?.isEmpty)! || (txtEmail.text?.isEmpty)! || (txtUsername.text?.isEmpty)! || (txtPassword.text?.isEmpty)! || (txtConfirmPassword.text?.isEmpty)! {
            let fieldAlertController = UIAlertController(title: "Alert", message: "Must fill in all field to submit.", preferredStyle: .alert)
            fieldAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(fieldAlertController, animated: true)
        }
        
        if ((txtPassword.text?.elementsEqual(txtConfirmPassword.text!))! != true)
        {
            let passwordMatchAlertController = UIAlertController(title: "Alert", message: "Passwords must match.", preferredStyle: .alert)
            passwordMatchAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(passwordMatchAlertController, animated: true)
        }
        
        let user = PFUser()
        user.username = txtUsername.text
        user.password = txtPassword.text
        user.email = txtEmail.text
        user["first_name"] = txtFirstName.text
        user["last_name"] = txtLastName.text
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        user.signUpInBackground { (success, error) in
            UIViewController.removeSpinner(spinner: sv)
            if success{
                let personalizationViewController = self.storyboard?.instantiateViewController(withIdentifier: "PersonalizationViewController") as! PersonalizationViewController
                self.present(personalizationViewController, animated: true, completion: nil)
            } else {
                if let descrip = error?.localizedDescription{
                    self.displayErrorMessage(message: descrip)
                }
            }
        }
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
