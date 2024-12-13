//
//  APIManager.swift
//  RZBD
//
//  Created by Дмитрий Комаров on 13.12.2024.
//

import Foundation
import SwiftUI
import Combine


// Класс для управления данными пользователей
class UserViewModel: ObservableObject {
    @Published var users = [User]()
    var cancellables = Set<AnyCancellable>()
    
    // Получение всех пользователей
    func fetchUsers() {
        print("Hello world!")
        guard let url = URL(string: "http://127.0.0.1:8000/users") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [User].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching users: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] users in
                self?.users = users
            }
            .store(in: &cancellables)
    }
    
    // Добавление нового пользователя
    func addUser(gender: Int, age: Int, user_rating: String) {
        let newUser = User(gender: gender, age: age, user_rating: user_rating)
        guard let url = URL(string: "http://127.0.0.1:8000/users/") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encodedUser = try JSONEncoder().encode(newUser)
            request.httpBody = encodedUser
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Failed to add user:", error)
                } else if let data = data {
                    print("User added successfully:", data)
                }
            }
            .resume()
        } catch {
            print("Failed to encode user:", error)
        }
    }
    
    // Редактирование пользователя
    func editUser(id: String, gender: Int, age: Int, user_rating: String) {
        let updatedUser = User(gender: gender, age: age, user_rating: user_rating)
        guard let url = URL(string: "http://127.0.0.1:8000/users/\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encodedUser = try JSONEncoder().encode(updatedUser)
            request.httpBody = encodedUser
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Failed to edit user:", error)
                } else if let data = data {
                    print("User edited successfully:", data)
                }
            }
            .resume()
        } catch {
            print("Failed to encode user:", error)
        }
    }
    
    // Удаление пользователя
    func deleteUser(id: String) {
        guard let url = URL(string: "http://127.0.0.1:8000/users/\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to delete user:", error)
            } else if let data = data {
                print("User deleted successfully:", data)
            }
        }
        .resume()
    }
}
