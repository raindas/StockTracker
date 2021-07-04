//
//  DateController.swift
//  StockTracker
//
//  Created by President Raindas on 03/07/2021.
//

import Foundation

final class DateController {
    
    private func epochToHumanDate(timestamp: Int) -> Date {
        let epochTime = TimeInterval(timestamp)
        return Date(timeIntervalSince1970: epochTime)
    }
    
    public func epochToStandardDate(timestamp: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: epochToHumanDate(timestamp: timestamp))
    }
    
    public func dateDifferece(timestamp: Int) -> String {
        var difference = ""
        
        let diffComponents = Calendar.current.dateComponents([.year,.month,.day,.hour, .minute, .second], from: epochToHumanDate(timestamp: timestamp), to: Date())
        
        let years = diffComponents.year
        let months = diffComponents.month
        let days = diffComponents.day
        let hours = diffComponents.hour
        let minutes = diffComponents.minute
        let seconds = diffComponents.second
        
        if years! > 0 {
            difference = years! == 1 ? "\(years!) year ago" : "\(years!) years ago"
        } else if months! > 0 {
            difference = months! == 1 ? "\(months!) month ago" : "\(months!) months ago"
        } else if days! > 0 {
            difference = days! == 1 ? "\(days!) day ago" : "\(days!) days ago"
        } else if hours! > 0 {
            difference = hours! == 1 ? "\(hours!) hour ago" : "\(hours!) hours ago"
        } else if minutes! > 0 {
            difference = minutes! == 1 ? "\(minutes!) minute ago" : "\(minutes!) minutes ago"
        } else if seconds! > 0 {
            difference = seconds! == 1 ? "\(seconds!) second ago" : "\(seconds!) seconds ago"
        } else {
            difference = "Unable to figure out date"
        }
        
        return difference
    }
}
