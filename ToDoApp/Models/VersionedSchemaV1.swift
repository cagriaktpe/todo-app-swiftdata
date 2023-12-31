//
//  VersionSchemaV1.swift
//  ToDoApp
//
//  Created by Samet Çağrı Aktepe on 27.10.2023.
//

import Foundation
import SwiftData
import UIKit

struct VersionedSchemaV1: VersionedSchema {
    static var models: [any PersistentModel.Type] {
        [ToDoItem.self, Category.self]
    }
    
    static var versionIdentifier: Schema.Version = .init(1, 0, 0)
}

extension VersionedSchemaV1 {
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
            case imageName
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            title = try container.decode(String.self, forKey: .title)
            timestamp = Date.randomDateNextWeek() ?? .now
            isCritical = try container.decode(Bool.self, forKey: .isCritical)
            isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
            category = try container.decodeIfPresent(Category.self, forKey: .category)
            if let imageName = try container.decodeIfPresent(String.self, forKey: .imageName) {
                let image = UIImage(named: imageName)
                self.image = image?.jpegData(compressionQuality: 0.8)
            }
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
