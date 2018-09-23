//
//  FancyBtn.swift
//  Beauty If Ugly
//
//  Created by Can KINCAL on 01/03/2017.
//  Copyright © 2017 Can KINCAL. All rights reserved.
//

import UIKit
@IBDesignable
class FancyBtn: UIButton {

    @IBInspectable
    var cornerRadius: CGFloat = 1.0
    @IBInspectable
    var cornerRadiuss: CGFloat = 1.0
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        layer.cornerRadius = cornerRadius
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
       // layer.cornerRadius = cornerRadiuss
    }

    
}
