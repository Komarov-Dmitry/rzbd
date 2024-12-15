//
//  Ride.swift
//  RZBD
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 14.12.2024.
//

import Foundation
struct Ride: Codable, Identifiable {
    // Статический счётчик ID
    private static var currentID: Int = 51
    
    var id: Int
    var user_id: String
    var car_id: String
    var ride_duration: Int
    var distance: Float
    var ride_cost: Float
    
    enum CodingKeys: String, CodingKey {
        case id = "ride_id"
        case user_id
        case car_id
        case ride_duration
        case distance
        case ride_cost
    }
    
    // Инициализатор с автоматическим инкрементом ID
    init(user_id: String, car_id: String, ride_duration: Int, distance: Float, ride_cost: Float) {
        self.id = Ride.generateNextID() // Автоинкремент
        self.user_id = user_id
        self.car_id = car_id
        self.ride_duration = ride_duration
        self.distance = distance
        self.ride_cost = ride_cost
    }
    
    // Генерация следующего уникального ID
    private static func generateNextID() -> Int {
        currentID += 1
        return currentID
    }
}
