//
//  ContentView.swift
//  StockTracker
//
//  Created by President Raindas on 27/06/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [])
    private var stockWatchlist: FetchedResults<StockWatchlist>
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Stock Tracker")
                        .font(.largeTitle.bold())
                    Text(Date(), style: .date).bold().foregroundColor(.secondary)
                }
                
                Spacer()
                
            }.padding()
            
            SearchBar(text: self.$viewModel.searchQuery).onChange(of: viewModel.searchQuery) {query in
                // perform function when search query changes
                viewModel.fetchSymbols(query: query)
            }
            
            List {
                ForEach (viewModel.symbolSearchResult, id: \.self) {
                    searchResult in
                    if viewModel.searchQuery != "" {
                            Button(action: {
                                viewModel.addToWatchlist(symbol: searchResult.displaySymbol, description: searchResult.description, viewContext: viewContext)
                                viewModel.searchQuery = ""
                                // dismiss keyboard
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }, label: {
                                VStack(alignment:.leading) {
                                    Text(searchResult.displaySymbol).font(.title)
                                    Text(searchResult.description).font(.footnote).foregroundColor(.secondary)
                                }
                            })
                    }
                }
                
                ForEach(stockWatchlist) { stock in
                    if viewModel.searchQuery == "" {
                        StockListItemView(symbol: stock.tickerSymbol!, description: stock.tickerSymbolDescription!)
                    }
                }.onDelete(perform: deleteItems)
            }
        }
        .alert(isPresented: self.$viewModel.searchQueryAlertTrigger, content: {
            Alert(title: Text("Error Encountered"),
                  message: Text(viewModel.searchQueryAlertMsg),
                  dismissButton: .default(Text("OK")))
        })
        .toolbar(content: {
            EditButton()
        })
    }
    
    private func deleteItems(offsets: IndexSet) {
        offsets.map { stockWatchlist[$0] }.forEach(viewContext.delete)
        viewModel.saveContext(context: viewContext)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewModel())
    }
}
