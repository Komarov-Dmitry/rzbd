//
//  ContentView.swift
//  RZBD
//
//  Created by Дмитрий Комаров on 13.12.2024.
//
import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0 // 0 for User, 1 for Admin
    @State private var selectedTable = 0
    
    @ObservedObject var viewModel = UserViewModel()
    @ObservedObject var carsViewModel = CarsViewModel()
//    @ObservedObject var viewModel = RidesViewModel()
    
    @State private var showingEditView = false
    
    @State private var showingAddUserView = false
    @State private var showingAddCarView = false
    
    
    @State private var selectedUser: User?
    @State private var selectedCar: Car?
    
    @State private var newUserGender = 1
    @State private var newUserAge = ""
    @State private var newUserRating = ""
    

    
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // User Tab
            userPage
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("User")
                }
                .tag(1)
                .navigationTitle("User List")
            
            // Admin Tab
            adminPage
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Admin")
                }
                .tag(0)
        }
    }
    
    var adminPage: some View {
        VStack {
            Picker("Admin", selection: $selectedTable) {
                Text("Users").tag(0)
                Text("Cars").tag(1)
                Text("Rides").tag(2)
                Text("Analytics").tag(3)
            }
            .padding()
            .pickerStyle(SegmentedPickerStyle())
            Spacer()
            if selectedTable == 0 {
                VStack {
                    List(viewModel.users) { user in
                        HStack {
                            Text(user.gender == 1 ? "Male" : "Female")
                            Text("\(user.age) years old")
                            Text("Rating: \(user.user_rating)")
                        }
                        .onTapGesture {
                            self.selectedUser = user
                            self.showingEditView = true
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.deleteUser(id: user.id)
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                }
            } else if selectedTable == 1 {
                VStack {
                    List(carsViewModel.cars) { car in
                        HStack {
                            VStack(alignment: .leading) {
                                HStack(alignment: .center) {
                                    Text(car.model)
                                        .font(.headline)
                                Text("\(car.yearToStart)".replacingOccurrences(of: " ", with: ""))
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                }
                                Text("\(car.carType.capitalized) | \(car.fuelType.capitalized)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("Rating: \(car.carRating)")
                                Text("Riders: \(car.riders)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 4)
                        .onTapGesture {
                            self.selectedCar = car
                            self.showingEditView = true
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                carsViewModel.deleteCar(id: car.id)
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                }
            } else if selectedTable == 2 {
                Text("Rides View")
            } else if selectedTable == 3 {
                Text("Anal")
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()
                Button(action: {
                    if selectedTable == 0 {
                        self.showingAddUserView = true
                        self.selectedUser = nil
                    } else if selectedTable == 1 {
                        self.showingAddCarView = true
                        self.selectedCar = nil
                    }
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                .padding()
            }
        }
        .sheet(isPresented: $showingEditView, content: {
            if let selectedUser = selectedUser {
                EditUserView(user: selectedUser)
            } else {
                NewUserView(viewModel: viewModel)
            }
        })
        .onAppear {
            viewModel.fetchUsers()
            carsViewModel.fetchCars()
        }
       
    }
    
    var userPage: some View {
        Text("FUCK YOU")
    }
}

#Preview {
    ContentView()
}



