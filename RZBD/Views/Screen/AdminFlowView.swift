//
//  AdminFlowView.swift
//  RZBD
//
//  Created by Дмитрий Комаров on 13.12.2024.
//

import SwiftUI
import Charts

struct AdminFlowView: View {
    @State private var selectedTab = 0

    @ObservedObject var viewModel = APIClient()

    @State private var showingAddCarView = false
    @State private var showingAddUserView = false
    @State var isEdit = false

    @State private var selectedUser: User?
    @State private var selectedCar: Car?
    @State private var selectedRide: Ride?

    var body: some View {
//        Button("Add smth") {
//            let newCar = Car(model: "DADAADDDD", carType: "CAR", fuelType: "FEFW", yearToStart: 2024, yearToWork: 1)
//            viewModel.addData(newCar, to: "cars/") { result in
//                switch result {
//                case .success(let id):
//                    print("Car added successfully with ID: \(id)")
//                case .failure(let error):
//                    print("Failed to add car: \(error.localizedDescription)")
//                }
//            }
//        }
        TabView(selection: $selectedTab) {
            UserListView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Users")
                }
                .tag(0)

            CarsListView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "car")
                    Text("Cars")
                }
                .tag(1)

            RideListView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "fuelpump")
                    Text("Rides")
                }
                .tag(2)
            UserRatingPieChartView(users: viewModel.users)
                .tabItem {
                    Image(systemName: "chart.xyaxis.line")
                    Text("Analtics")
                }
                .tag(3)
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()
                Button(action: {
                    if selectedTab == 0 {
                        print("Add user")
                        showingAddUserView = true
                    } else if selectedTab == 1 {
                        print("Add car")
                        showingAddCarView = true
                    }
                }) {
                    Image(systemName: "plus")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                }
                .padding(.bottom, 70)
                .padding(.trailing, 20)
            }
        }
        .sheet(isPresented: $showingAddCarView) {
            AddCarView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingAddUserView) {
            AddUserView(viewModel: viewModel)
        }
    }
    
    var AnalyticsView: some View {
        VStack {
            Text("Analytics Page")
                .font(.largeTitle)
                .padding()
//            pieChartView
        }
    }
}

#Preview {
    AdminFlowView()
}
