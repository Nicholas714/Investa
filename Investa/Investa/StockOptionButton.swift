//
//  StockOptionButton.swift
//  Investa
//
//  Created by Nicholas Grana on 10/20/18.
//  Copyright © 2018 hackgt. All rights reserved.
//

import UIKit

@IBDesignable class StockOptionButton: UIButton {
    
    @IBInspectable var circle: Bool = false {
        didSet {
            layer.cornerRadius = min(frame.height, frame.width) * 0.8 / 2
            layer.masksToBounds = true
        }
    }
    
}
