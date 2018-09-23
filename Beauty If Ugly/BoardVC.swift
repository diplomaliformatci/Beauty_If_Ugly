//
//  BoardVC.swift
//  Beauty If Ugly
//
//  Created by Can KINCAL on 01/03/2017.
//  Copyright © 2017 Can KINCAL. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
class BoardVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

 
    @IBAction func signOutTapped(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("Descripion: Data deleted from keychain \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    

}

