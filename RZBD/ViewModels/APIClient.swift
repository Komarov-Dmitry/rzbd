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
                completion(.success(decodedData))
            }
            .store(in: &cancellables)
    }
    
    func sendRideData(_ rideDict: Ride) {
        
        if let data = try? JSONEncoder().encode(rideDict),
           var dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any]  {
            
            
            guard let url = URL(string: "https://example.com/api/rides") else {
                print("Некорректный URL")
                return
            }
            
            dict.removeValue(forKey: "ride_id")
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: rideDict, options: []) else {
                print("Ошибка сериализации JSON")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Ошибка запроса: \(error)")
                    return
                }
                
                if let response = response as? HTTPURLResponse {
                    print("Код ответа: \(response.statusCode)")
                }
                
                if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                    print("Ответ от сервера: \(responseBody)")
                }
            }
            
            
            task.resume()
        }
    }
    
    func addCar(_ ride: Ride, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "http://localhost:8000/rides/") else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(ride)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Логирование данных, полученных от сервера
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response from server: \(responseString)")
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let responseModel = try JSONDecoder().decode(Ride.self, from: data)
                completion(.success(String(responseModel.id)))
            } catch {
                print("Decoded response error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    func addData<T: Encodable>(_ data: T, to endpoint: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: baseURL + "/" + endpoint + "/") else {
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
    
    func updateEntity<T: Encodable>(_ editedItem: T, at endpoint: String, id: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: baseURL + "/" + endpoint + "/" + id) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(editedItem)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NSError(domain: "Server Error", code: -2, userInfo: nil)))
                return
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                completion(.success(responseString))
            } else {
                completion(.failure(NSError(domain: "No Data", code: -3, userInfo: nil)))
            }
        }.resume()
    }
    
    // Универсальный метод для удаления данных
    func deleteData(at endpoint: String, id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: baseURL + "/" + endpoint + "/" + id) else {
            print("try url")
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("url: ", url)
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

