//
//  Stock.swift
//  Investa
//
//  Created by Nicholas Grana on 10/20/18.
//  Copyright © 2018 hackgt. All rights reserved.
//

import Foundation

class Stock: Decodable, Equatable {
    static func == (lhs: Stock, rhs: Stock) -> Bool {
        return lhs.ticker == rhs.ticker
    }
    
    
    let ticker: String
    var currentPrice: Float
    var initialPrice: Float = 0.0
    var sharesOwned = 0
    var history: [PastStockPoint]
    
    enum CodingKeys: String, CodingKey {
        typealias RawValue = String
        case currentPrice = "current_price"
        case ticker
        case history = "stocks"
    }
    
//    let stocks: Any
    
//    var sharesOwned: Int
    
//    let history: [Date: Float]
    
    init(ticker: String, currentPrice: Float) {
        self.ticker = ticker
//        self.sharesOwned = 1
        self.currentPrice = currentPrice
        self.history = [PastStockPoint]()
    }
    
    // percent success or not success
    // pull from begining of today and compare to now 
//    var percent: Int {
//        return 570
//    }
    
}


class PastStockPoint: Decodable, Equatable {
    static func == (lhs: PastStockPoint, rhs: PastStockPoint) -> Bool {
        return lhs.time == rhs.time 
    }
    
    let price: Float
    let time: String
    
    // 2018-10-19T15:00:00Z
    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD'T'HH:mm:ss'Z'"
        return dateFormatter.date(from: time)
    }
    
}
