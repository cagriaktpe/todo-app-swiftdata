//
//  ContentView.swift
//  ToDoApp
//
//  Created by Samet Cagri Aktepe on 12/10/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var showCreate = false

    var body: some View {
        NavigationStack {
            Text("Hello")
                .toolbar {
                    ToolbarItem {
                        Button(action: {
                            showCreate.toggle()
                        }, label: {
                            Label("Add Item", systemImage: "plus")
                        })
                    }
                }
                .sheet(isPresented: $showCreate, content: {
                    NavigationStack {
                        CreateView()
                    }
                    .presentationDetents([.medium])
                })
        }
    }
}

#Preview {
    ContentView()
}
