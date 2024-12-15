//
//  RideListView.swift
//  RZBD
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 15.12.2024.
//

import Foundation
import SwiftUI

struct RideListView: View {
    @ObservedObject var viewModel: APIClient
    @State var selectedRide: Ride?
    @State var conditionFilter: String?
    
    
    var body: some View {
        NavigationStack {
            List(viewModel.rides) { ride in
                if conditionFilter != nil {
                    if ride.user_id == conditionFilter {
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
                } else {
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
        .navigationTitle("Rides")
    }
}

#Preview {
    @Previewable var viewModel = APIClient()
    RideListView(viewModel: viewModel, conditionFilter: "N20291135p")
}
