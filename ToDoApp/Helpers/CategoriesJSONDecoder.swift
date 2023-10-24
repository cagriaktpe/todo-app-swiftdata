//
//  CategoriesJSONDecoder.swift
//  ToDoApp
//
//  Created by Samet Cagri Aktepe on 14/10/2023.
//

import Foundation

struct DefaultsJSON {
    static func decode<T: Decodable>(from fileName: String, type: T.Type) -> T? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let result = try? JSONDecoder().decode(T.self, from: data) else { return nil }
        
        return result
    }
}
