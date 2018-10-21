//
//  GraphHeaderView.swift
//  Investa
//
//  Created by Nicholas Grana on 10/20/18.
//  Copyright © 2018 hackgt. All rights reserved.
//

import UIKit

class GraphHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var label: UILabel! 
    @IBOutlet weak var rightLabel: UILabel! {
        didSet {
            rightLabel.textColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        }
    }
    
}
