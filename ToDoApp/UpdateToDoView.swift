//
//  UpdateToDoView.swift
//  ToDoApp
//
//  Created by Samet Cagri Aktepe on 12/10/2023.
//

import SwiftUI
import SwiftData

struct UpdateToDoView: View {
    @Environment(\.dismiss) var dismiss
    
    @Query private var categories: [Category]
    
    @Bindable var item: ToDoItem
    
    var body: some View {
        List {
            Section("ToDo Title") {
                TextField("Name", text: $item.title)
            }
            
            Section {
                DatePicker("Choose a date", selection: $item.timestamp)
                Toggle("Important?", isOn: $item.isCritical)
            }
            
            Section {
                Picker("Category", selection: $item.category) {
                    ForEach(categories) { category in
                        Text(category.title)
                            .tag(category as Category?)
                    }
                    Text("None")
                        .tag(nil as Category?)
                }
                .labelsHidden()
                .pickerStyle(.inline)
            
            }
            
            Section {
                Button("Done") {
                    withAnimation {
                        dismiss()
                    }
                }
            }
        }
        .navigationTitle("Update ToDo")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    dismiss()
                }
            }
        }
    }
}
