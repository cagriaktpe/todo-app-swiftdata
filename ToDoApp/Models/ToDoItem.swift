//
//  ToDoItem.swift
//  ToDoApp
//
//  Created by Samet Cagri Aktepe on 12/10/2023.
//

import Foundation
import SwiftData
import UIKit

extension ToDoItem: Identifiable {
    static var dummy: ToDoItem {
        .init(title: "Item 1",
              timestamp: .now,
              isCritical: true)
    }
}
