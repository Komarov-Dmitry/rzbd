//
//  Ride.swift
//  RZBD
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 14.12.2024.
//

import Foundation

struct Ride: Codable, Identifiable {
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
    // [{"ride_id":2,"user_id":"W94567191G","car_id":"d-1499264O","ride_duration":136,"distance":6662.7,"ride_cost":1491.0},
    init(id: Int = UUID().hashValue, user_id: String, car_id: String, ride_duration: Int, distance: Float, ride_cost: Float) {
        self.id = id
        self.user_id = user_id
        self.car_id = car_id
        self.ride_duration = ride_duration
        self.distance = distance
        self.ride_cost = ride_cost
    }
    
    
    
}
