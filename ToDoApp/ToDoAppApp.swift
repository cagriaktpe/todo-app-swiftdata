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
            VersionedSchemaV2.self,
            VersionedSchemaV3.self
        ]
    }
    
    static var stages: [MigrationStage] {
        [
            migrateV1toV2,
            migrateV2toV3
        ]
    }
    
    static let migrateV1toV2 = MigrationStage.lightweight(
        fromVersion: VersionedSchemaV1.self,
        toVersion: VersionedSchemaV2.self
    )
    
    static let migrateV2toV3 = MigrationStage.custom(
        fromVersion: VersionedSchemaV2.self,
        toVersion: VersionedSchemaV3.self,
        willMigrate: nil
    ) { context in
        let items = try? context.fetch(FetchDescriptor<VersionedSchemaV3.ToDoItem>())
        
        items?.forEach { item in
            item.isFlagged = false
            item.isArchived = false
        }
        
        try? context.save()
    }
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
