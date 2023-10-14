//
//  Category.swift
//  ToDoApp
//
//  Created by Samet Cagri Aktepe on 14/10/2023.
//

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

extension Category {
    static var defaults: [Category] {
        [
            .init(title: "🙇🏾‍♂️ Study"),
            .init(title: "🤝 Routine"),
            .init(title: "🏠 Family"),
        ]
    }
}
