//
//  CarsViewModel.swift
//  RZBD
//
//  Created by Дмитрий Комаров on 13.12.2024.
//

import Foundation
import SwiftUI
import Combine

class CarsViewModel: ObservableObject {
    @Published var cars: [Car] = []
    var cancellables = Set<AnyCancellable>()
    
    // Получение всех автомобилей
    func fetchCars() {
        guard let url = URL(string: "http://127.0.0.1:8000/cars") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Car].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching cars: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] cars in
                print("\(cars[0].yearToStart)")
                self?.cars = cars
            }
            .store(in: &cancellables)
    }
    
    // Добавление нового автомобиля
    func addCar(model: String, carType: String, fuelType: String, carRating: String, yearToStart: Int, yearToWork: Int, riders: Int, reserve: Int = 0) {
        let newCar = Car(model: model, carType: carType, fuelType: fuelType, carRating: carRating, yearToStart: yearToStart, yearToWork: yearToWork, riders: riders, reserve: reserve)
        guard let url = URL(string: "http://127.0.0.1:8000/cars/") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encodedCar = try JSONEncoder().encode(newCar)
            request.httpBody = encodedCar
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Failed to add car:", error)
                } else if let data = data {
                    print("Car added successfully:", data)
                }
            }
            .resume()
        } catch {
            print("Failed to encode car:", error)
        }
    }
    
    // Редактирование автомобиля
    func editCar(id: String, model: String, carType: String, fuelType: String, carRating: String, yearToStart: Int, yearToWork: Int, riders: Int, reserve: Int) {
        let updatedCar = Car(model: model, carType: carType, fuelType: fuelType, carRating: carRating, yearToStart: yearToStart, yearToWork: yearToWork, riders: riders, reserve: reserve)
        guard let url = URL(string: "http://127.0.0.1:8000/cars/\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encodedCar = try JSONEncoder().encode(updatedCar)
            request.httpBody = encodedCar
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Failed to edit car:", error)
                } else if let data = data {
                    print("Car edited successfully:", data)
                }
            }
            .resume()
        } catch {
            print("Failed to encode car:", error)
        }
    }
    
    // Удаление автомобиля
    func deleteCar(id: String) {
        guard let url = URL(string: "http://127.0.0.1:8000/cars/\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to delete car:", error)
            } else if let data = data {
                print("Car deleted successfully:", data)
            }
        }
        .resume()
    }
}
