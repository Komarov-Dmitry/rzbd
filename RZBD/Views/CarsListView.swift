//
//  CarsListView.swift
//  RZBD
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 14.12.2024.
//

import Foundation
import SwiftUI

struct CarsListView: View {
    @ObservedObject var viewModel: APIClient
    @State var selectedCar: Car?
    @State private var showingAECarView = false
    @State var isEdit = false
    var colors: [Color] = [.blue, .yellow, .green, .black, .gray, .brown, .cyan, .indigo, .mint, .pink, .purple]
    
    var body: some View {
        NavigationStack {
            List(viewModel.cars) { car in
                VStack(alignment: .leading) {
                    Image(systemName: "car")
                        .foregroundStyle(colors[Int.random(in: 0..<colors.count)])
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
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(.yellow)
                                Text("\(String(format: "%.1f", car.carRating).trimmingCharacters(in: CharacterSet(charactersIn: "0").union(.punctuationCharacters)))")
                            }
                            Text("Riders: \(car.riders)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 4)
                    .onTapGesture {
                        print("You tapped on a car")
                        showingAECarView = true
                        isEdit = true
                        self.selectedCar = car
                    }
                    .swipeActions(edge: .leading) {
                        Button(action: {
                            let index = viewModel.cars.firstIndex(where: {$0.id == car.id})
                            if let index = index {
                                // increment reserve
                                var editedCar = viewModel.cars[index]
                                editedCar.reserve += 1
                                print(car.id)
                                viewModel.updateData(editedCar, at: "cars", id: car.id) { result in
                                    switch result {
                                    case .success:
                                        viewModel.loadAllData()
                                    case .failure(let error):
                                        print("Error updating car: \(error)")
                                    }
                                }
                                
                                // add ride
                                var newRide = Ride(user_id: "S21145976p", car_id: "kejgkqn24KM", ride_duration: 10, distance: 100, ride_cost: 100)
                                print("NewRide ID : ", newRide.id)
                                viewModel.addCar(newRide) { result in
                                    switch result {
                                    case .success:
                                        print("Succes adding ride")
//                                        viewModel.loadAllData()
                                    case .failure(let error):
                                        print("Error adding ride: \(error)")
                                    }
                                    
                                }
                            }
                        }) {
                            Label("", systemImage: "steeringwheel")
                        }
                       .tint(.purple)
                    }
                    .swipeActions {
                        
                        Button(role: .destructive) {
                            print(car.id)
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
            .navigationTitle("Cars")
            .sheet(isPresented: $showingAECarView) {
                EditCarView(viewModel: viewModel, selectedCar: $selectedCar)
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
    }
    
}

#Preview {
    @Previewable var viewModel = APIClient()
    CarsListView(viewModel: viewModel)
}
