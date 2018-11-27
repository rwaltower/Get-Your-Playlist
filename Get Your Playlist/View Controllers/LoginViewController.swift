//
//  LoginViewController.swift
//  Get Your Playlist
//
//  Created by Radasia Waltower on 11/17/18.
//  Copyright © 2018 Team 6. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var btnForgotPassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var fields: UITextField = [txtUsername, txtPassword]
        
        //Calling methods to design text field
        roundCorners_AddPadding(txtField: fields)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let username = txtUsername.text
        let password = txtPassword.text
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        PFUser.logInWithUsername(inBackground: username!, password: password!) { (user, error) in
            UIViewController.removeSpinner(spinner: sv)
            if user != nil {
                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                self.present(homeViewController, animated: true)
            }else{
                if let descrip = error?.localizedDescription{
                    self.displayErrorMessage(message: (descrip))
                }
            }
        }
    }
    
    //Customizes text fields with rounded corners and padding
    func roundCorners_AddPadding(txtField: [UITextField])
    {
        //Set padding
        let paddingView = UIView(frame: CGRectMake(0, 0, 25, field.frame.height))
        
        for field in txtField
        {
            field.leftView = paddingView
            
            field.layer.cornerRadius = 15.0
            field.layer.borderWidth = 2.0
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
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.present(registerViewController, animated: true)
    }
    
    
}

