//
//  StocksModel.swift
//  StockTracker
//
//  Created by President Raindas on 29/06/2021.
//

import Foundation

//struct StockQuote: Decodable {
//    var quote: Stock
//}

struct Stock: Codable {
    var currentPrice: Double
    var highPrice: Double
    var lowPrice: Double
    var openingPrice: Double
    var previousClosePrice: Double
    var timeStamp: Int
    var change: String {
        let percentageDiffRaw = ((currentPrice-previousClosePrice)/previousClosePrice)*100 //<-- Raw figure that hasn't been rounded
        let percentageDiff = String(format: "%.2f", percentageDiffRaw)//<-- Rounded to 2 decimal places
        return "\(percentageDiff)%"
    }
    
    enum CodingKeys: String, CodingKey {
        case currentPrice = "c"
        case highPrice = "h"
        case lowPrice = "l"
        case openingPrice = "o"
        case previousClosePrice = "pc"
        case timeStamp = "t"
    }
    
}

struct MarketNews: Codable {
    var category: String
    var datetime: Int
    var headline: String
    var id: Int
    var image: String
    var source: String
    var summary: String
    var url: String
}
