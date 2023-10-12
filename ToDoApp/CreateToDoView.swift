//
//  CreatView.swift
//  ToDoApp
//
//  Created by Samet Cagri Aktepe on 12/10/2023.
//

import SwiftUI

struct CreateToDoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            TextField("Name", text: .constant(""))
            DatePicker("Choose a date", selection: .constant(.now))
            Toggle("Important?", isOn: .constant(false))
            Button("Create") {
                dismiss()
            }
        
        }
        .navigationTitle("Create ToDo")
    }
}

#Preview {
    CreateToDoView()
}
