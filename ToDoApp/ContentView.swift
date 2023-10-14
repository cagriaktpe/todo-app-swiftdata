//
//  ContentView.swift
//  ToDoApp
//
//  Created by Samet Cagri Aktepe on 12/10/2023.
//

import SwiftData
import SwiftUI

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

    @Query(
        filter: #Predicate { $0.isCompleted == false },
        sort: \ToDoItem.timestamp
    ) private var items: [ToDoItem]

    var filteredItems: [ToDoItem] {
        if searchQuery.isEmpty {
            return items
        } else {
            return items.filter { item in
                item.title.lowercased().contains(searchQuery.lowercased()) ||
                    item.category?.title.lowercased().contains(searchQuery.lowercased()) ?? false
            }
        }
    }

    var body: some View {
        NavigationStack {
            List {
                if items.isEmpty {
                    ContentUnavailableView("No Todo", systemImage: "checkmark.circle")
                } else {
                    ForEach(filteredItems) { item in
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
                                toDoToEdit = item
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.orange)
                        }
                    }
                }
            }
            .navigationTitle("My Todo List")
            .searchable(text: $searchQuery, prompt: "Search for a todo or a category")
            .overlay {
                if filteredItems.isEmpty {
                    ContentUnavailableView.search
                }
            }
            .toolbar {
                /** ToolbarItem {
                     Button(action: {
                         showCreateCategory.toggle()
                     }, label: {
                         Text("New Category")
                     })
                 */
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

#Preview {
    ContentView()
}
