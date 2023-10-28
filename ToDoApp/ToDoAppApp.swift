//
//  ToDoAppApp.swift
//  ToDoApp
//
//  Created by Samet Cagri Aktepe on 12/10/2023.
//

import SwiftUI
import SwiftData

// MARK: SwiftData models
typealias ToDoItem = VersionedSchemaV3.ToDoItem
typealias Category = VersionedSchemaV3.Category

// MARK: Migration plan
enum ToDosMigrationPlan: SchemaMigrationPlan {
    static var schemas: [VersionedSchema.Type] {
        [
            VersionedSchemaV1.self,
            VersionedSchemaV2.self
        ]
    }
    
    static var stages: [MigrationStage] {
        [migrateV1toV2]
    }
    
    static let migrateV1toV2 = MigrationStage.lightweight(
        fromVersion: VersionedSchemaV1.self,
        toVersion: VersionedSchemaV2.self
    )
}

@main
struct ToDoAppApp: App {
    @AppStorage("isFirstTimeLaunch") var isFirstTimeLaunch: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(ItemsContainer.create(shouldCreateDefaults: &isFirstTimeLaunch))
        }
    }
}
