//
//  ToDoItem.swift
//  ToDoApp
//
//  Created by Samet Cagri Aktepe on 12/10/2023.
//

import Foundation
import SwiftData

@Model
final class ToDoItem: Codable {
    var title: String
    var timestamp: Date
    var isCritical: Bool
    var isCompleted: Bool
    
    @Attribute(.externalStorage)
    var image: Data?
    
    @Relationship(deleteRule: .nullify, inverse: \Category.items)
    var category: Category?
    
    init(title: String = "", timestamp: Date = .now, isCritical: Bool = false, isCompleted: Bool = false) {
        self.title = title
        self.timestamp = timestamp
        self.isCritical = isCritical
        self.isCompleted = isCompleted
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case timestamp
        case isCritical
        case isCompleted
        case category
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.timestamp = Date.randomDateNextWeek() ?? .now
        self.isCritical = try container.decode(Bool.self, forKey: .isCritical)
        self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        self.category = try container.decodeIfPresent(Category.self, forKey: .category)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(isCritical, forKey: .isCritical)
        try container.encode(isCompleted, forKey: .isCompleted)
        try container.encode(category, forKey: .category)
    }
    
}
