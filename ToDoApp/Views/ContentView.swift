//
//  ContentView.swift
//  ToDoApp
//
//  Created by Samet Cagri Aktepe on 12/10/2023.
//

import SwiftData
import SwiftUI
import SwiftUIImageViewer

enum SortOption: String, CaseIterable {
    case title
    case date
    case category
}

extension SortOption {
    var systemImage: String {
        switch self {
        case .title:
            "textformat.size.larger"
        case .date:
            "calendar"
        case .category:
            "folder"
        }
    }
}

struct ContentView: View {
    @Environment(\.modelContext) var modelContext

    @State private var showCreateToDo = false
    @State private var showCreateCategory = false
    @State private var toDoToEdit: ToDoItem?
    @State private var searchQuery = ""
    @State private var selectedSortOption = SortOption.allCases.first!
    @State private var isImageViewerPresented = false

    @Query private var items: [ToDoItem]

    var filteredItems: [ToDoItem] {
        if searchQuery.isEmpty {
            return items.sort(by: selectedSortOption)
        } else {
            let filteredItems = items.filter { item in
                item.title.lowercased().contains(searchQuery.lowercased()) ||
                    item.category?.title.lowercased().contains(searchQuery.lowercased()) ?? false
            
            }
            
            return filteredItems.sort(by: selectedSortOption)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredItems) { item in
                    VStack {
                        // display image from item
                        if let imageData = item.image,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: 128)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .onTapGesture {
                                    isImageViewerPresented = true
                                }
                                .fullScreenCover(isPresented: $isImageViewerPresented) {
                                    SwiftUIImageViewer(image: Image(uiImage: uiImage))
                                        .overlay(alignment: .topTrailing) {
                                            Button {
                                                isImageViewerPresented = false
                                            } label: {
                                                Image(systemName: "xmark")
                                                    .font(.headline)
                                            }
                                            .buttonStyle(.bordered)
                                                    .clipShape(Circle())
                                                    .tint(.blue)
                                                    .padding()
                                        }
                                }
                        }
                        
                        HStack {
                            // MARK: Content

                            VStack(alignment: .leading) {
                                if item.isCritical {
                                    Image(systemName: "exclamationmark.3")
                                        .symbolVariant(.fill)
                                        .foregroundColor(.red)
                                        .font(.largeTitle)
                                        .bold()
                                }

                                Text(item.title)
                                    .font(.largeTitle)
                                    .bold()

                                Text("\(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .shortened))")
                                    .font(.callout)

                                if let category = item.category {
                                    Text(category.title)
                                        .foregroundStyle(Color.blue)
                                        .bold()
                                        .padding(.horizontal)
                                        .padding(.vertical, 8)
                                        .background(Color.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                                }
                            }

                            Spacer()

                            Button {
                                withAnimation {
                                    item.isCompleted.toggle()
                                }
                            } label: {
                                Image(systemName: "checkmark")
                                    .symbolVariant(.circle.fill)
                                    .foregroundStyle(item.isCompleted ? .green : .gray)
                                    .font(.largeTitle)
                            }
                            .buttonStyle(.plain)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button {
                                withAnimation {
                                    modelContext.delete(item)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)

                            Button {
                                withAnimation {
                                    toDoToEdit = item
                                }
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.orange)
                    }
                    }
                }
            }
            .navigationTitle("My Todo List")
            .animation(.easeIn, value: filteredItems)
            .searchable(text: $searchQuery, prompt: "Search for a todo or a category")
            .overlay {
                if items.isEmpty {
                    ContentUnavailableView("No Todos", systemImage: "checkmark.circle")
                }
                else if filteredItems.isEmpty {
                    ContentUnavailableView.search
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("", selection: $selectedSortOption) {
                            ForEach(SortOption.allCases,
                                    id: \.rawValue) { option in
                                Label(option.rawValue.capitalized,
                                      systemImage: option.systemImage)
                                    .tag(option)
                            }
                        }
                        .labelsHidden()

                    } label: {
                        Image(systemName: "ellipsis")
                            .symbolVariant(.circle)
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showCreateCategory.toggle()
                    } label: {
                        Label("New Category", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showCreateToDo, content: {
                NavigationStack {
                    CreateToDoView()
                }
                .presentationDetents([.large])
            })
            .sheet(item: $toDoToEdit) {
                toDoToEdit = nil
            } content: { item in
                NavigationStack {
                    UpdateToDoView(item: item)
                }
                .presentationDetents([.large])
            }
            .sheet(isPresented: $showCreateCategory, content: {
                NavigationStack {
                    CreateCategoryView()
                }
                .presentationDetents([.large])
            })
            .safeAreaInset(edge: .bottom, alignment: .leading) {
                Button {
                    showCreateToDo.toggle()
                } label: {
                    Label("New Todo", systemImage: "plus")
                        .bold()
                        .font(.title2)
                        .padding(0)
                        .background(.gray.opacity(0.1), in: Capsule())
                        .padding(.leading)
                        .symbolVariant(.circle.fill)
                }
            }
        }
    }
}

private extension [ToDoItem] {
    func sort(by option: SortOption) -> [ToDoItem] {
        switch option {
        case .title:
            return sorted(by: { $0.title < $1.title })
        case .date:
            return sorted(by: { $0.timestamp < $1.timestamp })
        case .category:
            return sorted(by: { $0.category?.title ?? "" < $1.category?.title ?? "" })
        }
    }
}


#Preview {
    ContentView()
}
