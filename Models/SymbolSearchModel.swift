//
//  SymbolSearchModel.swift
//  StockTracker
//
//  Created by President Raindas on 28/06/2021.
//

import Foundation

struct SymbolSearchResponse: Decodable {
    var result: [SymbolSearchResult]
}

struct SymbolSearchResult: Codable, Hashable {
    var displaySymbol: String
    var symbol: String
    var description: String
}
