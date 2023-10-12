//
//  CreateCategoryView.swift
//  ToDoApp
//
//  Created by Samet Cagri Aktepe on 12/10/2023.
//

import SwiftUI
import SwiftData

@Model
class Category {
    @Attribute(.unique)
    var title: String
    
    var items: [ToDoItem]?
    
    init(title: String = "") {
        self.title = title
    }
}

struct CreateCategoryView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var title: String = ""
    @Query private var categories: [Category]
    
    var body: some View {
        List {
            Section("Category Title") {
                TextField("Enter title here", text: $title)
                Button("Add Category") {
                    modelContext.insert(Category(title: title))
                }
                .disabled(title.isEmpty)
            }
            
            Section("Categories") {
                ForEach(categories) { category in
                    Text(category.title)
                }
            }
        }
        .navigationTitle("Add Category")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Dismiss") {
                    dismiss()
                }
            }
        }
    
    }
}

#Preview {
    NavigationStack {
        CreateCategoryView()
    }
}
