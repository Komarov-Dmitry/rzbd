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
            .navigationTitle("Cars")
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
