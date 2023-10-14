//
//  ToDoAppApp.swift
//  ToDoApp
//
//  Created by Samet Cagri Aktepe on 12/10/2023.
//

import SwiftUI
import SwiftData

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
