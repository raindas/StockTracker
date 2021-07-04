//
//  StockTrackerApp.swift
//  StockTracker
//
//  Created by President Raindas on 27/06/2021.
//

import SwiftUI

@main
struct StockTrackerApp: App {
    
    let persistenceController = PersistenceController.shared
    @StateObject var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem { Label("Watchlist", systemImage: "list.star") }
                NewsView()
                    .tabItem { Label("News", systemImage: "newspaper") }
            }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(viewModel)
        }
    }
}
