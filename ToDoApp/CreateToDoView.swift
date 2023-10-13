//
//  CreatView.swift
//  ToDoApp
//
//  Created by Samet Cagri Aktepe on 12/10/2023.
//

import SwiftUI
import SwiftData

struct CreateToDoView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Query private var categories: [Category]
    
    @State private var item = ToDoItem()
    @State var selectedCategory: Category?
    
    var body: some View {
        List {
            Section("Todo Title") {
                TextField("Name", text: $item.title)
            }
            
            Section("General") {
                DatePicker("Choose a date", selection: $item.timestamp)
                Toggle("Important?", isOn: $item.isCritical)
            }
            
            Section("Select A Category")  {
                if categories.isEmpty {
                    ContentUnavailableView("No Categories", systemImage: "archivebox")
                
                } else {
                    Picker("Category", selection: $selectedCategory) {
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
                
            }
            
            Section {
                Button("Create") {
                    withAnimation {
                        save()
                        dismiss()
                    }
                }
            }
        }
        .navigationTitle("Create Todo")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    save()
                    dismiss()
                }
                .disabled(item.title.isEmpty)
            }
        
        }
    
    }
}

private extension CreateToDoView {
    func save() {
        withAnimation {
            modelContext.insert(item)
            item.category = selectedCategory
            selectedCategory?.items?.append(item)
        }
        dismiss()
    }

}


#Preview {
    CreateToDoView()
        .modelContainer(for: ToDoItem.self)
}
