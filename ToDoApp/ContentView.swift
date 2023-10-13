//
//  ContentView.swift
//  ToDoApp
//
//  Created by Samet Cagri Aktepe on 12/10/2023.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext

    @State private var showCreateToDo = false
    @State private var showCreateCategory = false

    @State private var toDoToEdit: ToDoItem?
    @Query(
        filter: #Predicate { $0.isCompleted == false },
        sort: \ToDoItem.timestamp
    ) private var items: [ToDoItem]

    var body: some View {
        NavigationStack {
            List {
                if items.isEmpty {
                    ContentUnavailableView("No ToDo", systemImage: "checkmark.circle")
                } else {
                    ForEach(items) { item in
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
            .navigationTitle("My ToDo List")
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        showCreateCategory.toggle()
                    }, label: {
                        Text("New Category")
                    })
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
                    Label("New ToDo", systemImage: "plus")
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
