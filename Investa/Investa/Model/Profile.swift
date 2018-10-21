//
//  Profile.swift
//  Investa
//
//  Created by Tillson Galloway on 10/20/18.
//  Copyright © 2018 hackgt. All rights reserved.
//

import Foundation

class Profile: Decodable {
    
    let name: String

    var funds: Float
    let startingFunds = 15000.0

    var ownedStocks = [Stock]()
    let portfolioValue: Float
    
    enum CodingKeys: String, CodingKey {
        typealias RawValue = String
        case name
        case funds
        case portfolioValue = "value"
    }
    
    init(name: String, portfolioValue: Float) {
        self.name = name
        self.portfolioValue = portfolioValue
        self.funds = portfolioValue
        self.ownedStocks = [Stock]()
    }
    
}
