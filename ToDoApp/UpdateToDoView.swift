//
//  UpdateToDoView.swift
//  ToDoApp
//
//  Created by Samet Cagri Aktepe on 12/10/2023.
//

import SwiftData
import SwiftUI

struct UpdateToDoView: View {
    @Environment(\.dismiss) var dismiss

    @Query private var categories: [Category]

    @Bindable var item: ToDoItem

    var body: some View {
        List {
            Section("ToDo Title") {
                TextField("Name", text: $item.title)
            }

            Section("General") {
                DatePicker("Choose a date", selection: $item.timestamp)
                Toggle("Important?", isOn: $item.isCritical)
            }

            Section("Select A Category") {
                if categories.isEmpty {
                    ContentUnavailableView("No Categories", systemImage: "archivebox")

                } else {
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
            }

            Section {
                Button("Update") {
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
