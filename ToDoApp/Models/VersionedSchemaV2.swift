//
//  VersionedSchemaV2.swift
//  ToDoApp
//
//  Created by Samet Çağrı Aktepe on 28.10.2023.
//

import Foundation
import SwiftData
import UIKit

struct VersionedSchemaV2: VersionedSchema {
    static var models: [any PersistentModel.Type] {
        [ToDoItem.self, Category.self]
    }
    
    static var versionIdentifier: Schema.Version = .init(1, 0, 1)
}

extension VersionedSchemaV2 {
    @Model
    final class ToDoItem: Codable {
        var title: String
        @Attribute(originalName: "timestamp")
        var dueDate: Date
        var isCritical: Bool
        var isCompleted: Bool

        @Attribute(.externalStorage)
        var image: Data?

        @Relationship(deleteRule: .nullify, inverse: \Category.items)
        var category: Category?

        init(title: String = "", dueDate: Date = .now, isCritical: Bool = false, isCompleted: Bool = false) {
            self.title = title
            self.dueDate = dueDate
            self.isCritical = isCritical
            self.isCompleted = isCompleted
        }

        enum CodingKeys: String, CodingKey {
            case title
            case timestamp
            case isCritical
            case isCompleted
            case category
            case imageName
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.title = try container.decode(String.self, forKey: .title)
            self.dueDate = Date.randomDateNextWeek() ?? .now
            self.isCritical = try container.decode(Bool.self, forKey: .isCritical)
            self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
            self.category = try container.decodeIfPresent(Category.self, forKey: .category)
            if let imageName = try container.decodeIfPresent(String.self, forKey: .imageName) {
                let image = UIImage(named: imageName)
                self.image = image?.jpegData(compressionQuality: 0.8)
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(title, forKey: .title)
            try container.encode(dueDate, forKey: .timestamp)
            try container.encode(isCritical, forKey: .isCritical)
            try container.encode(isCompleted, forKey: .isCompleted)
            try container.encode(category, forKey: .category)
        }
    }
    
    @Model
    class Category: Codable {
        @Attribute(.unique)
        var title: String

        var items: [ToDoItem]?

        init(title: String = "") {
            self.title = title
        }
        
        enum CodingKeys: String, CodingKey {
            case title
        }
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            title = try container.decode(String.self, forKey: .title)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try? container.encode(title, forKey: .title)
        }
    }
}



