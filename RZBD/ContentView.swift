//
//  ContentView.swift
//  RZBD
//
//  Created by Дмитрий Комаров on 13.12.2024.
//
import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var selectedTable = 0

    @ObservedObject var viewModel = APIClient()

    @State private var showingAddUserView = false
    @State private var showingAddCarView = false

    @State private var selectedUser: User?
    @State private var selectedCar: Car?
    @State private var selectedRide: Ride?

    var body: some View {
        TabView(selection: $selectedTab) {
            userPage
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("User")
                }
                .tag(1)

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
                userList
            } else if selectedTable == 1 {
                carList
            } else if selectedTable == 2 {
                rideList
            } else if selectedTable == 3 {
                Text("Analytics")
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
                        .fontWeight(.bold)
                }
                .padding(.bottom, 40)
                .padding(.trailing, 30)
            }
        }
        //        .sheet(isPresented: $showingEditView, content: {
        //            if let selectedUser = selectedUser {
        //                EditUserView(user: selectedUser)
        //            } else {
        //                NewUserView(viewModel: viewModel)
        //            }
        //        })
    }
    
    var userPage: some View {
        Text("User Page")
    }

    var userList: some View {
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

    var carList: some View {
        List(viewModel.cars) { car in
            VStack(alignment: .leading) {
                Image(systemName: "car")
                HStack {
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Text(car.model)
                                .font(.headline)
                            Text("\(car.yearToStart)")
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
                }
                .swipeActions {
                    Button(role: .destructive) {
                        viewModel.deleteData(at: "cars", id: car.id) { result in
                            switch result {
                            case .success:
                                viewModel.loadAllData()
                            case .failure(let error):
                                print("Error deleting car: \(error)")
                            }
                        }
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchData(from: "cars", as: [Car].self) { result in
                switch result {
                case .success(let cars):
                    viewModel.cars = cars
    //                print("Fetched Cars: \(cars)")
                case .failure(let error):
                    print("Failed to fetch cars: \(error)")
                }
            }
        }
    }

    var rideList: some View {
        List(viewModel.rides) { ride in
            HStack {
                Image(systemName: "fuelpump")
                    .padding(.trailing, 15)
                VStack {
                    Text("\(ride.ride_duration)")
                    Text("Duration")
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack {
                    Text("\(String(format: "%.1f", ride.distance).trimmingCharacters(in: CharacterSet(charactersIn: "0").union(.punctuationCharacters)))")
                    Text("Distance")
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack {
                    Text("$ \(String(format: "%.1f", ride.ride_cost).trimmingCharacters(in: CharacterSet(charactersIn: "0").union(.punctuationCharacters)))")
                    Text("Ride cost")
                        .foregroundColor(.gray)
                }
                .onTapGesture {
                    self.selectedRide = ride
                }
            }
        }
        .onAppear {
            viewModel.fetchData(from: "rides", as: [Ride].self) { result in
                switch result {
                case .success(let rides):
                    viewModel.rides = rides
                case .failure(let error):
                    print("Failed to fetch rides: \(error)")
                }
            }
        }
    }

    
    
}

#Preview {
    ContentView()
}
