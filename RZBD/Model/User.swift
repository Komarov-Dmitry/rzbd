//
//  User.swift
//  RZBD
//
//  Created by Дмитрий Комаров on 13.12.2024.
//

import Foundation

struct User: Codable, Identifiable {
    
    var id: String
    var gender: Int
    var age: Int
    var user_rating: Float
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case gender
        case age
        case user_rating
    }
    
    // Инициализатор для генерации UUID
    init(gender: Int, age: Int, user_rating: Float) {
        self.id = String(UUID().uuidString.prefix(20))
        self.gender = gender
        self.age = age
        self.user_rating = user_rating
    }
}
