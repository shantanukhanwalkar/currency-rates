//
//  Rates.swift
//  CurrencyRates
//
//  Created by Shantanu Khanwalkar on 22/03/18.
//  Copyright © 2018 Shantanu Khanwalkar. All rights reserved.
//

import Foundation

struct Rates: Codable {
    var rates: [Rate]
}

struct Rate: Codable {
    var symbol: String
    var price: Double
}
