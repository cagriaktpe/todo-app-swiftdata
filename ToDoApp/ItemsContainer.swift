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
            Category.defaults.forEach { container.mainContext.insert($0) }
            shouldCreateDefaults = false
        }
        return container
    }
}
