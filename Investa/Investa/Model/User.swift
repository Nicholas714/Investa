//
//  User.swift
//  Investa
//
//  Created by Tillson Galloway on 10/20/18.
//  Copyright © 2018 hackgt. All rights reserved.
//
import Foundation

class User: Profile {
    
    let username: String
    var transactions = [Transaction]()
    
    override init(name: String, portfolioValue: Float) {
        self.username = name
        super.init(name: name, portfolioValue: portfolioValue)
    }
 
//    //won't get called
    required init(from decoder: Decoder) throws {
        self.username = ""
        try super.init(from: decoder)
    }
    
}
