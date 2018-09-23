//
//  DataService.swift
//  Beauty If Ugly
//
//  Created by Can KINCAL on 03/03/2017.
//  Copyright © 2017 Can KINCAL. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper
let DB_BASE = FIRDatabase.database().reference()
let DB_STORAGE = FIRStorage.storage().reference()
class DataService {
    
    static let ds = DataService()
    
    //DB references
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    //DB Storage references
    private var _REF_POST_IMAGES = DB_STORAGE.child("post-pics")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USER_CURRENT: FIRDatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_POST_IMAGES: FIRStorageReference {
        return _REF_POST_IMAGES
    }
    
    func createFirebaseDBUser(uid: String,userData:  Dictionary<String , String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    
}
