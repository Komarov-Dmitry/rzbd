//
//  Car.swift
//  RZBD
//
//  Created by Дмитрий Комаров on 13.12.2024.
//

import Foundation

struct Car: Codable, Identifiable {
    
    var id: String
    var model: String
    var carType: String
    var fuelType: String
    var carRating: Float
    var yearToStart: Int
    var yearToWork: Int
    var riders: Int
    var reserve: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "car_id"
        case model
        case carType = "car_type"
        case fuelType = "fuel_type"
        case carRating = "car_rating"
        case yearToStart = "year_to_start"
        case yearToWork  = "year_to_work"
        case riders
        case reserve
    }
    
    init(model: String, carType: String, fuelType: String, carRating: Float = 5.0, yearToStart: Int, yearToWork: Int, riders: Int = 0, reserve: Int = 0) {
        self.id = String(UUID().uuidString.prefix(20))
        self.model = model
        self.carType = carType
        self.fuelType = fuelType
        self.carRating = carRating
        self.yearToStart = yearToStart
        self.yearToWork = yearToWork
        self.riders = riders
        self.reserve = reserve
    }

}
