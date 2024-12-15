//
//  AdminFlowView.swift
//  RZBD
//
//  Created by Дмитрий Комаров on 13.12.2024.
//

import SwiftUI

struct AdminFlowView: View {
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
            AnalyticsView
                .tabItem {
                    Image(systemName: "chart.xyaxis.line")
                    Text("Analtics")
                }
        }
    }


    var AnalyticsView: some View {
        VStack {
            Text("Analytics Page")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
    }
}

#Preview {
    AdminFlowView()
}
