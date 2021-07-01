//
//  StocksListView.swift
//  StockTracker
//
//  Created by President Raindas on 27/06/2021.
//

import SwiftUI

struct StockListItemView: View {
    // stock values
    let symbol: String
    let description: String
    
    @State var stockQuote = Stock(currentPrice: 0.0, highPrice: 0.0, lowPrice: 0.0, openingPrice: 0.0, previousClosePrice: 0.0, timeStamp: 0)
    
    @State var alertTrigger = false
    @State var alertMsg = ""
    
    var body: some View {
        VStack {
            HStack {
                Text(symbol)
                Spacer()
                Text("$\(String(stockQuote.currentPrice))")
            }.font(.title.bold())
            
            HStack {
                Text(description)
                Spacer()
                Text(stockQuote.change)
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
                    .padding(.trailing, 5)
                    .padding(.leading, 10)
                    .background(stockQuote.change.contains("-") ? Color.red : Color.green)
                    .cornerRadius(8)
            }.font(.subheadline.bold())
        }.padding()
        .onAppear(perform: {
            fetchSymbol(ticker: symbol)
        })
        .alert(isPresented: $alertTrigger, content: {
            Alert(title: Text("Error Encountered"),
                  message: Text(alertMsg),
                  dismissButton: .default(Text("OK")))
        })
    }
    // get stock details
    func fetchSymbol(ticker: String) {
        // define URL
        guard let url = URL(string: "https://finnhub.io/api/v1/quote?symbol=\(ticker)&token=sandbox_c3d2ma2ad3i868dopia0") else {
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
//                                let decodedResponse = try JSONDecoder().decode(Stock.self, from: data)
//                    self.stockQuote = decodedResponse.self
//                            } catch {
//                                print("Unable to decode JSON -> \(error)")
//                            }
                let decodedResponse = try? JSONDecoder().decode(Stock.self, from: data)
                if let decodedResponse = decodedResponse {
                   // print(decodedResponse)
                    DispatchQueue.main.async {
                        self.stockQuote = decodedResponse
                    }
                    return
                }
                print(data)
            }
            //print("Quote fetch request failed: \(error?.localizedDescription ?? "Unknown Error")")
            alertMsg = error?.localizedDescription ?? "Unknown Error"
            alertTrigger.toggle()
        }.resume()
    }
}

struct StockListItemView_Previews: PreviewProvider {
    static var previews: some View {
        StockListItemView(symbol: "AAPL", description: "Apple Inc.")
    }
}
