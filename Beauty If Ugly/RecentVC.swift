//
//  RecentVC.swift
//  Beauty If Ugly
//
//  Created by Can KINCAL on 01/03/2017.
//  Copyright © 2017 Can KINCAL. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
class RecentVC: UIViewController , UITableViewDelegate , UITableViewDataSource , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: CircleView!
    @IBOutlet weak var captionField: FancyField!
   
    
    var imageSelected: Bool = false
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    
    
    static var imageCache: NSCache<NSString , UIImage> = NSCache()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker  = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
            
        })
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        //print("Description: \(post.caption)")
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell{
            
            if let img = RecentVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
            } else {
                cell.configureCell(post: post)
            }
            return cell
        }else {
            return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        }
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
            imageSelected = true
        } else {
            print("Description: A v alid image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func postBtnTapped(_ sender: Any) {
        guard let caption = captionField.text , caption != "" else {
            print("Description: Caption must be entered")
            return
        }
        
        guard let img = imageAdd.image , imageSelected == true else {
            print("Description: An image Must be Selected")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            DataService.ds.REF_POST_IMAGES.child(imgUid).put(imgData , metadata: metadata) {(metadata , error) in
                
                if error != nil {
                    print("Description: Unable to upload image To Firebase Storage")
                } else {
                    print("Description: Succesfully uploaded image to Firebase Storage")
                    if let downloadURL = metadata?.downloadURL()?.absoluteString {
                        self.postToFirebase(imgUrl: downloadURL)
                    }
                }
                
            }
        }
        
    }
    
    func postToFirebase(imgUrl: String) {
        let post: Dictionary<String , AnyObject> = [
            "caption" : captionField.text! as AnyObject,
            "imageUrl" : imgUrl as AnyObject ,
            "likes" : 0 as AnyObject
            // Other information will come here
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        self.captionField.text = ""
        self.imageSelected  = false
        imageAdd.image = UIImage(named: "profile_icon")
        
        self.tableView.reloadData()
    }
    
    
    @IBAction func signOutTapped(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("Descripion: Data deleted from keychain \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    
    
}

