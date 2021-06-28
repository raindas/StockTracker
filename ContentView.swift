//
//  ContentView.swift
//  StockTracker
//
//  Created by President Raindas on 27/06/2021.
//

import SwiftUI

struct Stock: Identifiable {
    let id = UUID()
    var symbol: String
    var description: String
    var price: String
    var change: String
}

struct ContentView: View {
    
    @State var symbolSearchResult = [SymbolSearchResult]()
    
    @State private var searchQuery = ""
    
    var stock = [
        Stock(symbol: "AAPL", description: "Apple Inc.", price: "127.10", change: "1.33%"),
        Stock(symbol: "SBUX", description: "Starbucks Corporation", price: "54.38", change: "-2.62%"),
        Stock(symbol: "MSFT", description: "Microsoft Corporation", price: "79.12", change: "1.05%")
    ]
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Stock Tracker")
                        .font(.largeTitle.bold())
                    Text(Date(), style: .date).bold().foregroundColor(.secondary)
                }
                
                Spacer()
                
//                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
//                    Image(systemName: "pencil.circle.fill")
//                        .font(.largeTitle)
//                        .foregroundColor(.purple)
//                })
            }.padding()
            
            SearchBar(text: $searchQuery).onChange(of: searchQuery) {query in
                // perform function when search query changes
                fetchSymbol(query: query)
            }
            
            List {
                ForEach (symbolSearchResult, id: \.self) {
                    searchResult in
                    if searchQuery != "" {
                        VStack(alignment:.leading) {
                            Text(searchResult.displaySymbol).font(.title)
                            Text(searchResult.description).font(.footnote).foregroundColor(.secondary)
                        }
                    }
                }
                
                ForEach(stock) { stockItem in
                    if searchQuery == "" {
                        StockListItemView(symbol: stockItem.symbol, description: stockItem.description, price: stockItem.price, change: stockItem.change)
                    }
                }
            }
        }
    }
    
    // get stock symbol
    func fetchSymbol(query: String) {
        // define URL
        guard let url = URL(string: "https://finnhub.io/api/v1/search?q=\(query)&token=sandbox_c3d2ma2ad3i868dopia0") else {
            print("Invalid URL")
            return
        }
        // create URL Request
        let request = URLRequest(url: url)
        // create and start a networking task with the URL request
        // URL Session is the iOS class responsible for managing network requests
        URLSession.shared.dataTask(with: request) { data, response, error in
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
            print("Fetch request failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
