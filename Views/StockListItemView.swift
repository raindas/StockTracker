//
//  StocksListView.swift
//  StockTracker
//
//  Created by President Raindas on 27/06/2021.
//

import SwiftUI

struct StockListItemView: View {
    
    let dateController = DateController()
    // stock values
    let symbol: String
    let description: String
    
    @Binding var lastStockActivityDate: String
    
    @State var stockQuote = Stock(currentPrice: 0.0, highPrice: 0.0, lowPrice: 0.0, openingPrice: 0.0, previousClosePrice: 0.0, timeStamp: 0)
    
    @State private var alertTrigger = false
    @State private var alertMsg = ""
    @State private var detailScreenModal = false
    
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
        .onTapGesture {
            self.detailScreenModal.toggle()
        }
        .alert(isPresented: $alertTrigger, content: {
            Alert(title: Text("Error Encountered"),
                  message: Text(alertMsg),
                  dismissButton: .default(Text("OK")))
        })
        .sheet(isPresented: $detailScreenModal, content: {
            StockDetailView(detailScreenModal: $detailScreenModal, open: stockQuote.openingPrice, high: stockQuote.highPrice, low: stockQuote.lowPrice, current: stockQuote.currentPrice, prevClose: stockQuote.previousClosePrice, change: stockQuote.change, symbol: symbol, description: description)
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
                        self.lastStockActivityDate = dateController.epochToStandardDate(timestamp: stockQuote.timeStamp)
                    }
                    return
                }
                print(data)
            }
            //print("Quote fetch request failed: \(error?.localizedDescription ?? "Unknown Error")")
            self.lastStockActivityDate = "Unable to fetch date"
            alertMsg = error?.localizedDescription ?? "Unknown Error"
            alertTrigger.toggle()
        }.resume()
    }
}

struct StockListItemView_Previews: PreviewProvider {
    static var previews: some View {
        StockListItemView(symbol: "AAPL", description: "Apple Inc.", lastStockActivityDate: .constant(""))
    }
}
