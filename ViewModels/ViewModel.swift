//
//  ViewModel.swift
//  StockTracker
//
//  Created by President Raindas on 01/07/2021.
//

import Foundation
import CoreData

final class ViewModel: ObservableObject {
    @Published var symbolSearchResult = [SymbolSearchResult]()
    @Published var marketNews = [MarketNews]()
    @Published var searchQuery = ""
    @Published var searchQueryAlertTrigger = false
    @Published var searchQueryAlertMsg = ""
    
    var token = "c3d2ma2ad3i868dopi9g"
    var sandboxToken = "sandbox_c3d2ma2ad3i868dopia0"
    
    private func isAddedToWatchlist (context: NSManagedObjectContext, tickerSymbol: String) -> Bool {
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "StockWatchlist")
        let res = (try? context.fetch(req)) as? [NSManagedObject] ?? []
        
        let num:[String] = res.compactMap {
            ($0.value(forKey: ("tickerSymbol")) as! String)
        }
        
        if num.contains(tickerSymbol) {
           // print("\(symbol) exists")//<-- change this later for Alert message
            
            return true
        } else {
            return false
        }
    }
    
    public func addToWatchlist(symbol: String, description: String,viewContext: NSManagedObjectContext) {
        // check if Ticker Symbol is already in the watch list
        if isAddedToWatchlist(context: viewContext, tickerSymbol: symbol) {
            searchQueryAlertMsg = "Ticker Symbol \"\(symbol)\" is already on your watchlist."
            searchQueryAlertTrigger.toggle()
        } else {
            let newStockSymbol = StockWatchlist(context: viewContext)
            newStockSymbol.tickerSymbol = symbol
            newStockSymbol.tickerSymbolDescription = description
            saveContext(context: viewContext)
        }
        
    }
    
    public func saveContext(context: NSManagedObjectContext){
        do {
            try context.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }
    
    // get stock symbol
    public func fetchSymbols(query: String) {
        // define URL
        guard let url = URL(string: "https://finnhub.io/api/v1/search?q=\(query)&token=\(sandboxToken)") else {
            print("Invalid URL")
            return
        }
        // create URL Request
        let request = URLRequest(url: url)
        // create and start a networking task with the URL request
        // URL Session is the iOS class responsible for managing network requests
        URLSession.shared.dataTask(with: request) { [self] data, response, error in
            if let data = data {
                let decodedResponse = try? JSONDecoder().decode(SymbolSearchResponse.self, from: data)
                if let decodedResponse = decodedResponse {
                    //print(decodedResponse)
                    DispatchQueue.main.async {
                        self.symbolSearchResult = decodedResponse.result
                    }
                    return
                }
            }
            //print("Fetch request failed: \(error?.localizedDescription ?? "Unknown Error")")
            DispatchQueue.main.async {
                searchQueryAlertMsg = error?.localizedDescription ?? "Unknown Error"
                searchQueryAlertTrigger.toggle()
            }
        }.resume()
    }
    
    // get market news
    func fetchNews(type: String, ticker: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        // the negative sign makes us deduct the number of seconds from the current date
        let sevenDaysAgo = formatter.string(from: Date().addingTimeInterval(-(86400 * 7)))//<-- 86400 seconds = 7 day, (86400 * 7) seconds = 7 days
        let today = formatter.string(from: Date())
        
        var urlString: String {
            return type == "general" ? "https://finnhub.io/api/v1/news?category=general&token=\(token)" : "https://finnhub.io/api/v1/company-news?symbol=\(ticker)&from=\(sevenDaysAgo)&to=\(today)&token=\(token)"
        }
        
        // define URL
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        // create URL Request
        let request = URLRequest(url: url)
        // create and start a networking task with the URL request
        // URL Session is the iOS class responsible for managing network requests
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
//                do {
//                                let decodedResponse = try JSONDecoder().decode([MarketNews].self, from: data)
//                    self.marketNews = decodedResponse
//                            } catch {
//                                print("Unable to decode JSON -> \(error)")
//                            }
                let decodedResponse = try? JSONDecoder().decode([MarketNews].self, from: data)
                if let decodedResponse = decodedResponse {
                    //print(decodedResponse)
                    DispatchQueue.main.async {
                        self.marketNews = decodedResponse
                    }
                    return
                }
            }
            print("News fetch request failed: \(error?.localizedDescription ?? "Unknown Error")")
//            alertMsg = error?.localizedDescription ?? "Unknown Error"
//            alertTrigger.toggle()
        }.resume()
    }
    
}
