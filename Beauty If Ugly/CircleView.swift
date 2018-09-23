//
//  CircleView.swift
//  Beauty If Ugly
//
//  Created by Can KINCAL on 03/03/2017.
//  Copyright © 2017 Can KINCAL. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    
  

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
      }
    
   
}
