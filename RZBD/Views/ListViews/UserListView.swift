//
//  UserListView.swift
//  RZBD
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 15.12.2024.
//

import Foundation
import SwiftUI

struct UserListView: View {
    
    @ObservedObject var viewModel: APIClient
    @State var selectedUser: User?
    @State private var isShowEditUserView = false
    
    var body: some View {
        NavigationStack {
            List(viewModel.users) { user in
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "person.fill")
                            Text(user.gender == 1 ? "Male" : "Female")
                        }
                        Text("\(user.age) years old")
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                        Text("\(String(format: "%.1f", user.user_rating).trimmingCharacters(in: CharacterSet(charactersIn: "0").union(.punctuationCharacters)))")
                    }

                }
                .onTapGesture {
                    isShowEditUserView = true
                    self.selectedUser = user
                }
                .swipeActions {
                    Button(role: .destructive) {
                        viewModel.deleteData(at: "users", id: user.id) { result in
                            switch result {
                            case .success:
    //                            viewModel.loadAllData()
                                print("Succes")
                            case .failure(let error):
                                print("Error deleting user: \(error)")
                            }
                        }
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
            .navigationTitle("Users")
            .sheet(isPresented: $isShowEditUserView) {
                EditUserView(viewModel: viewModel, selectedUser: $selectedUser)
            }
            .onAppear {
                viewModel.fetchData(from: "users", as: [User].self) { result in
                    switch result {
                    case .success(let users):
                        viewModel.users = users
                    case .failure(let error):
                        print("Failed to fetch users: \(error)")
                    }
                }
            }
        }
    }

}

#Preview {
    @Previewable var viewModel = APIClient()
    UserListView(viewModel: viewModel)
}
