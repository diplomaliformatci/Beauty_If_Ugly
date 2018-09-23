//
//  PostCell.swift
//  Beauty If Ugly
//
//  Created by Can KINCAL on 03/03/2017.
//  Copyright © 2017 Can KINCAL. All rights reserved.
//

import UIKit
import Firebase
class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var likesLbl: UILabel!
    var post: Post!
    var likesRef: FIRDatabaseReference!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
        
    }
    
    
    func configureCell(post: Post , img: UIImage? = nil) {
        self.post = post
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        if img != nil {
            self.postImg.image = img
        } else {
            let imageUrl = post.imageUrl
            let ref = FIRStorage.storage().reference(forURL: imageUrl)
            ref.data(withMaxSize: 2 * 1024 * 1024 , completion: {(data , error) in
                if error != nil {
                    print("Description: Unable to download image from Firebase Storage")
                } else {
                    print("Image Downloaded from Firebase Storage")
                    if let imageData = data {
                        if let image = UIImage(data: imageData) {
                            self.postImg.image = image
                            RecentVC.imageCache.setObject(image, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
            
        }
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.backgroundColor = UIColor.clear
            } else {
                self.likeImg.backgroundColor = UIColor.red
            }
        
    
})
}

    
    func likeTapped (sender: UITapGestureRecognizer) {
       
        print("Description: Like Button Tapped")
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.backgroundColor = UIColor.red
                self.post.udjustLikes(addLike: true)
                self.likesRef.setValue(true)
            } else {
                self.likeImg.backgroundColor = UIColor.clear
                self.post.udjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
            
        })

    }
    

}

