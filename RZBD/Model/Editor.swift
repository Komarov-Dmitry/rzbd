//
//  User.swift
//  RZBD
//
//  Created by Дмитрий Комаров on 13.12.2024.
//

import Foundation

struct Editor: Codable, Identifiable {
    var id = UUID() // Добавляем идентификатор для использования в List
    var full_name: String
    var position: String
    var phone: String
    
    enum CodingKeys: CodingKey {
        case full_name
        case position
        case phone
    }
}
