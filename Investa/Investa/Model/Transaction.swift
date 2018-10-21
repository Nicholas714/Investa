//
//  Transaction.swift
//  Investa
//
//  Created by Tillson Galloway on 10/20/18.
//  Copyright © 2018 hackgt. All rights reserved.
//

import Foundation

struct Transaction: Decodable {
    
    let ticker: String
    let buyPrice: Float
    let date: String
    let type: String // BUY or SELL
    let shares: Int
    
    enum CodingKeys: String, CodingKey {
        typealias RawValue = String
        case buyPrice = "price_at_time"
        case ticker
        case type
        case shares = "quantity"
        case date = "created_at"
    }
    
    init(ticker: String, buyPrice: Float, date: Date, type: String, shares: Int) {
        self.ticker = ticker
        self.buyPrice = buyPrice
        self.date = "\(date)"
        self.type = type
        self.shares = shares
    }

    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        print(date)
        dateFormatter.dateFormat = "YYYY-MM-DD'T'HH:mm:ss'Z'"
        return dateFormatter.date(from: date)
    }

    
}
