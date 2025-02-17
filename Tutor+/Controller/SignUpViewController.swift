//
//  SignUpViewController.swift
//  Tutor+
//
//  Created by jzhao33 on 10/17/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var majorTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.layer.cornerRadius = 5.0
        signUpButton.layer.masksToBounds = true

        // Do any additional setup after loading the view.
    }
    
    // keyboard issue
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func SignUpButtonOnClicked(_ sender: Any) {
        
        if let password1 = passwordTextField.text, let password2 = passwordConfirmTextField.text{
            if password1 != password2{
                AlertHelper.showAlert(fromController: self, message: "The passwords you typed are inconsistent!", buttonTitle: "OK")
                return
            }
        }
        
        if let email = emailTextField.text, let password = passwordTextField.text{
            // start to create a user
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in

                guard (authResult?.user) != nil else {
                    debugHelpPrint(type: ClassType.SignUpViewController, str: error.debugDescription)
                    AlertHelper.showAlert(fromController: self, message: error.debugDescription, buttonTitle: "OK")
                    
                    return
                }
                
                
                
                // Send email verification
                Auth.auth().currentUser?.sendEmailVerification { (error) in

                    if error != nil{
                        debugHelpPrint(type: ClassType.FirebaseUser, str: error.debugDescription)
                        AlertHelper.showAlert(fromController: self, message: error.debugDescription, buttonTitle: "OK")
                    
                    }else{
                        
                        // Intialize sign up information
                        FirebaseUser.shared.name = self.nameTextField.text
                        FirebaseUser.shared.major = self.majorTextField.text
                        // create initialized information
                        FirebaseUser.shared.uploadProfile()
                        // logout before doing anything
                        FirebaseUser.shared.logOut()
                    }
                    
                    return
                }
            }
        }
        
    }
}
