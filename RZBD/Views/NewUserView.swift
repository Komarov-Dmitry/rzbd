//
//  NewUserView.swift
//  RZBD
//
//  Created by Дмитрий Комаров on 13.12.2024.
//



import Foundation
import SwiftUI

struct NewUserView: View {
    @ObservedObject var viewModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var gender = 1
    @State private var age = ""
    @State private var user_rating: Float = 0.0

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("New User Details")) {
                    Picker("Gender", selection: $gender) {
                        Text("Male").tag(1)
                        Text("Female").tag(0)
                    }
                    TextField("Age", text: $age)
                    TextField("Rating", value: $user_rating, formatter: NumberFormatter())
//                    TextField("Rating", text: $user_rating, formatter: NumberFormatter())
                }
            }
            .navigationTitle("Add New User")
            .navigationBarItems(trailing: Button("Save") {
                guard let age = Int(age) else { return } // Ensure age is a valid integer
                viewModel.addUser(gender: gender, age: age, user_rating: user_rating)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
