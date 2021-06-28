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
    let price: String
    let change: String
    
    var body: some View {
        VStack {
            HStack {
                Text(symbol)
                Spacer()
                Text("$\(String(price))")
            }.font(.title.bold())
            
            HStack {
                Text(description)
                Spacer()
                Text(change)
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
                    .padding(.trailing, 5)
                    .padding(.leading, 10)
                    .background(change.contains("-") ? Color.red : Color.green)
                    .cornerRadius(8)
            }.font(.subheadline.bold())
        }.padding()
    }
}

struct StockListItemView_Previews: PreviewProvider {
    static var previews: some View {
        StockListItemView(symbol: "AAPL", description: "Apple Inc.", price: "127.10", change: "-110.83%")
    }
}
