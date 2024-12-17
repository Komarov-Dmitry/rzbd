//
//  EditUserView.swift
//  RZBD
//
//  Created by Дмитрий Комаров on 13.12.2024.
//

import Foundation
import SwiftUI

struct EditUserView: View {
    @ObservedObject var viewModel: APIClient
    @Binding var selectedUser: User?

    @Environment(\.presentationMode) var presentationMode
    @State private var gender = ""
    @State private var age = ""
    @State private var userRate = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Gender | Age")) {
                    TextField("Gender", text: $gender)
                    TextField("Age", text: $age)
                    TextField("Rating", text: $userRate)
                }
            }
            .onAppear {
                if let selectedUser = selectedUser {
                    gender = selectedUser.gender == 0 ? "Female" : "Male"
                    age = String(selectedUser.age)
                    userRate = String(selectedUser.user_rating)
                }
            }
            .navigationTitle("Edit User")
            .navigationBarItems(trailing: Button("Save changes") {
                var sex: Int = 0
                if ["Female", "female", "f", "F", "Ж", "Женский", "Жен", "ж", "женский", "жен", "0"].contains(gender) {
                    sex = 0
                } else if ["Male", "male", "m", "M", "М", "Мужской", "Муж", "м", "мужской", "муж", "1"].contains(gender) {
                    sex = 1
                }
                let editedUser = User(gender: sex, age: Int(age) ?? 18, user_rating: Float(userRate) ?? 5.0)
                viewModel.updateEntity(editedUser, at: "users", id: selectedUser!.id) { result in
                    switch result {
                    case .success:
                        print("Updated")
                    case .failure:
                        print("Error")
                    }
                }
                viewModel.loadAllData()
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}


