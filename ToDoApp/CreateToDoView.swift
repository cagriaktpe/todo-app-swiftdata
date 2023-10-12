//
//  CreatView.swift
//  ToDoApp
//
//  Created by Samet Cagri Aktepe on 12/10/2023.
//

import SwiftUI

struct CreateToDoView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var item = ToDoItem()
    
    var body: some View {
        List {
            TextField("Name", text: $item.title)
            DatePicker("Choose a date", selection: $item.timestamp)
            Toggle("Important?", isOn: $item.isCritical)
            Button("Create") {
                withAnimation {
                    modelContext.insert(item)
                }
                dismiss()
            }
        
        }
        .navigationTitle("Create ToDo")
    }
}

#Preview {
    CreateToDoView()
        .modelContainer(for: ToDoItem.self)
}
