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
            let categories = CategoryJSONDecoder.decode(from: "CategoryDefaults")
            if categories.isEmpty == false {
                categories.forEach { item in
                    let category = Category(title: item.title)
                    container.mainContext.insert(category)
                }
            }
            shouldCreateDefaults = false
        }
        return container
    }
}
