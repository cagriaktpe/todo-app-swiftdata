//
//  ItemsContainer.swift
//  ToDoApp
//
//  Created by Samet Cagri Aktepe on 14/10/2023.
//

import Foundation
import SwiftData

actor ItemsContainer {
    @MainActor
    static func create(shouldCreateDefaults: inout Bool) -> ModelContainer {
        let schema = Schema([ToDoItem.self])
        let configuration = ModelConfiguration()
        let container = try! ModelContainer(for: schema, configurations: configuration)
        if shouldCreateDefaults {
            shouldCreateDefaults = false
            let categories = DefaultsJSON.decode(from: "CategoryDefaults", type: [Category].self)
            categories?.forEach { category in
                container.mainContext.insert(category)
            }
            let items = DefaultsJSON.decode(from: "ToDoItemsDefaults", type: [ToDoItem].self)
            dump(items)
        }
        return container
    }
}

extension Date {
    static func randomDateNextWeek() -> Date? {
        let calendar = Calendar.current
        let currentDate = Date.now
        
        guard let nextWeekStartDate = calendar.date(byAdding: .day, value: 7, to: currentDate) else { return nil }
        
        // Random time within a week
        let randomTimeInterval = TimeInterval.random(in: 0..<7 * 24 * 60 * 60)
        
        let randomDate = nextWeekStartDate.addingTimeInterval(randomTimeInterval)
        
        return randomDate
    }
}
