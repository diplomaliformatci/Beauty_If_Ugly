//
//  SignInVC.swift
//  Beauty If Ugly
//
//  Created by Can KINCAL on 01/03/2017.
//  Copyright © 2017 Can KINCAL. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import SwiftKeychainWrapper
class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToPage", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func facebookBtnTapped(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Description: Unable to authenticate with Facebook - \(error)")
            } else if result?.isCancelled == true {
                print("Description: User cancelled Facebook authentication")
            } else {
                print("Description: Succesfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Description: Unable to authenticate with Firebase")
            } else {
                print("Description: Successfully authenticated with Firebase")
                if let user = user {
                    let userData = ["provider" : credential.provider]
                    self.completeSignIn(id: user.uid , userData: userData)
                }
            }
        })
    }
    
    
    @IBAction func signInTapped(_ sender: Any) {
        if let email = emailField.text , let pwd = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("Description: Email User authenticated with Firebase")
                    if let user = user {
                        let userData = ["provider" : user.providerID]
                        self.completeSignIn(id: user.uid , userData: userData)                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("Description: Unable to authenticate with Firebase using email")
                        } else {
                            print("Description: Succesfully authenticated with Firebase")
                            if let user = user {
                                let userData = ["provider" : user.providerID]
                                self.completeSignIn(id: user.uid , userData: userData)
                            }
                        }
                    })
                }
            })
        }
        
    }
    
    func completeSignIn(id: String , userData: Dictionary<String , String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Description: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToPage", sender: nil)
    }
    
    
    
}
