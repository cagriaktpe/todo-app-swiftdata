//
//  PreviewContainer.swift
//  ToDoApp
//
//  Created by Samet Çağrı Aktepe on 26.10.2023.
//

import Foundation
import SwiftData

struct PreviewContainer {
    let container: ModelContainer!
    
    init(_ types: [any PersistentModel.Type], isStoredInMemoryOnly: Bool = true) {
        let schema = Schema(types)
        let config = ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
        self.container = try! ModelContainer(for: schema, configurations: [config])
    }
    
    func add(items: [any PersistentModel]) {
        Task { @MainActor in
            items.forEach({ container.mainContext.insert($0) })
        }
    }
}
