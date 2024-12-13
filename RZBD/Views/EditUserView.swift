//
//  EditUserView.swift
//  RZBD
//
//  Created by Дмитрий Комаров on 13.12.2024.
//

import Foundation
import SwiftUI

struct EditUserView: View {
    @State var user: User
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = UserViewModel()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User Details")) {
                    Picker("Gender", selection: $user.gender) {
                        Text("Male").tag(1)
                        Text("Female").tag(0)
                    }
                    TextField("Age", value: $user.age, formatter: NumberFormatter())
                    
                    TextField("Rating", value: $user.user_rating, formatter: NumberFormatter())
                }
            }
            .navigationTitle("Edit User")
            .navigationBarItems(trailing: Button("Save") {
                viewModel.editUser(id: user.id, gender: user.gender, age: user.age, user_rating: user.user_rating)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
