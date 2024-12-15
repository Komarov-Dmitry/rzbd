//
//  CarshAPI.swift
//  RZBD
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 14.12.2024.
//

import Foundation
import Combine

class APIClient: ObservableObject {
    @Published var users: [User] = []
    @Published var cars: [Car] = []
    @Published var rides: [Ride] = []
    
    private let baseURL = "http://127.0.0.1:8000"
    private var cancellables = Set<AnyCancellable>()
    
    func fetchData<T: Decodable>(from endpoint: String, as type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: baseURL + "/" + endpoint) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: type, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            } receiveValue: { decodedData in
//                print("Decoded data \(decodedData)")
                completion(.success(decodedData))
            }
            .store(in: &cancellables)
    }
    
    func addData<T: Encodable>(_ data: T, to endpoint: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(data)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                } else if let data = data {
                    completion(.success(data))
                }
            }
            .resume()
        } catch {
            completion(.failure(error))
        }
    }
    
    func updateData<T: Encodable & Identifiable>(_ editedItem: T, at endpoint: String, id: String, completion: @escaping (Result<Data, Error>) -> Void) {
        // Сначала удаляем элемент
        deleteData(at: endpoint, id: id) { [weak self] result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success:
                // Если удаление прошло успешно, добавляем новый элемент
                self?.addData(editedItem, to: endpoint, completion: completion)
            }
        }
    }
    
    // Универсальный метод для удаления данных
    func deleteData(at endpoint: String, id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: baseURL + endpoint + "/" + id) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
        .resume()
    }
    
    func loadAllData() {
        
        // Fetch Users
        fetchData(from: "users", as: [User].self) { result in
            switch result {
            case .success(let users):
                self.users = users
//                print("Fetched Users: \(users)")
            case .failure(let error):
                print("Failed to fetch users: \(error)")
            }
        }
        
        // Fetch Cars
        fetchData(from: "cars", as: [Car].self) { result in
            switch result {
            case .success(let cars):
                self.cars = cars
//                print("Fetched Cars: \(cars)")
            case .failure(let error):
                print("Failed to fetch cars: \(error)")
            }
        }
        
        // Fetch Rides
        fetchData(from: "rides", as: [Ride].self) { result in
            switch result {
            case .success(let rides):
                self.rides = rides
//                print("Fetched Rides: \(rides)")
            case .failure(let error):
                print("Failed to fetch rides: \(error)")
            }
        }
    }
}



enum APIError: Error {
    case invalidURL
}

