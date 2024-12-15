//
//  UserFlowView.swift
//  RZBD
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 14.12.2024.
//

import Foundation
import SwiftUI


struct UserFlowView: View {
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
          

            CarsListView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "car")
                    Text("Cars")
                }
                .tag(0)

            RideListView(viewModel: viewModel, conditionFilter: "S21145976p")
                .tabItem {
                    Image(systemName: "fuelpump")
                    Text("Rides")
                }
                .tag(1)
            
            PersonalView
                .tabItem {
                    Image(systemName: "info.circle")
                    Text("User")
                }
                .tag(1)
        
        }
    }


    var PersonalView: some View {
        VStack {
            Image(systemName: "person")
                .resizable()
                .frame(width: 100, height: 100)
            Text("User Information")
                .font(.largeTitle)
                .padding()
            Text("User rating - 8.4")
        }
    }
}

#Preview {
    UserFlowView()
}
