//
//  CreatView.swift
//  ToDoApp
//
//  Created by Samet Cagri Aktepe on 12/10/2023.
//

import PhotosUI
import SwiftData
import SwiftUI

struct CreateToDoView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext

    @Query private var categories: [Category]

    @State private var item = ToDoItem()
    @State var selectedCategory: Category?

    @State var selectedPhoto: PhotosPickerItem?

    var body: some View {
        List {
            Section("Todo Title") {
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
                if let imageData = item.image,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, maxHeight: 300)
                }

                PhotosPicker(selection: $selectedPhoto,
                             matching: .images,
                             photoLibrary: .shared()) {
                    Label("Add Image", systemImage: "photo")
                }

                if item.image != nil {
                    Button(role: .destructive) {
                        withAnimation {
                            selectedPhoto = nil
                            item.image = nil
                        }
                    } label: {
                        Label("Remove Image", systemImage: "xmark")
                            .foregroundColor(.red)
                    }
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
        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                item.image = data
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
    SwiftDataViewer(preview: PreviewContainer([ToDoItem.self])) {
        CreateToDoView()
    }
}
