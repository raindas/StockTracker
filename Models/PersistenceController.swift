//
//  PersistenceController.swift
//  StockTracker
//
//  Created by President Raindas on 29/06/2021.
//

import Foundation
import CoreData

struct PersistenceController {
    
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "SavedStocks")
        
        container.loadPersistentStores{
            (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
}
