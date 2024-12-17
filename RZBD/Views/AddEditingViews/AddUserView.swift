//
//  AddUserView.swift
//  RZBD
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 16.12.2024.
//

import Foundation
import SwiftUI

struct AddUserView: View {
    @ObservedObject var viewModel: APIClient

    @State private var isShowGenderAlert = false
    @State private var showNextScreen = false
    @Environment(\.presentationMode) var presentationMode
    @State private var gender = ""
    @State private var age = ""
    @State private var showUserFlow = false
    @State private var createdUser: User? = nil // Хранение созданного пользователя

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Gender | Age")) {
                        TextField("Gender", text: $gender)
                        TextField("Age", text: $age)
                    }
                }
                
                //
                Button(action: {
                    // Создание пользователя и переход
//                    createdUser = User(gender: 1, age: 18, user_rating: 5.0)
                    addingUser()
                    showUserFlow = true
                }) {
                    Text("Register")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(8)
                }
                
                // NavigationLink для перехода на UserFlowView
                NavigationLink(
                    destination: UserFlowView(user: createdUser ?? User(gender: 1, age: 555, user_rating: 5.0)),
                    isActive: $showUserFlow
                ) {
                    EmptyView()
                }
                //
            }
            .alert(isPresented: $isShowGenderAlert) {
                Alert(title: Text("Incorrect gender or age. Try again"))
            }
            .navigationTitle("Adding User")
//            .navigationBarItems(trailing: Button("Add") {
//               addingCar()
//            })
        }
    }

    
    private func addingUser() {
        var sex: Int = 0
        var newUser: User
        if ["Female", "female", "f", "F", "Ж", "Женский", "Жен", "ж", "женский", "жен", "0"].contains(gender) {
            sex = 0
        } else if ["Male", "male", "m", "M", "М", "Мужской", "Муж", "м", "мужской", "муж", "1"].contains(gender) {
            sex = 1
        } else {
            isShowGenderAlert = true
        }
        
        if let ageNumber = Int(age) {
            if ageNumber < 18 {
                isShowGenderAlert = true
            } else {
                newUser = User(
                    gender: sex, age: Int(age) ?? 18, user_rating: 5.0
                )
                viewModel.addData(newUser, to: "users") { result in
                    switch result {
                    case .success:
                        print("User added successfully")
                    case .failure(let error):
                        print("Error adding user: \(error)")
                    }
                }
            }
        }
    }
}


#Preview {
    AddUserView(viewModel: APIClient())
}
