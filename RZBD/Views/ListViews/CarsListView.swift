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
    @State private var selectedCar: Car?
    @State private var showingAECarView = false
    @State private var isEdit = false
    private let colors: [Color] = [.blue, .yellow, .green, .black, .gray, .brown, .cyan, .indigo, .mint, .pink, .purple]
    var user: User?
    
    var body: some View {
        NavigationStack {
            List(viewModel.cars) { car in
                carRow(for: car)
            }
            .navigationTitle("Cars")
            .sheet(isPresented: $showingAECarView) {
                EditCarView(viewModel: viewModel, selectedCar: $selectedCar)
            }
            .onAppear(perform: fetchCars)
        }
    }
    
    @ViewBuilder
    private func carRow(for car: Car) -> some View {
        VStack(alignment: .leading) {
            Image(systemName: "car")
                .foregroundStyle(randomColor())
            
            HStack {
                carDetails(for: car)
                Spacer()
                carStats(for: car)
            }
            .padding(.vertical, 4)
            .onTapGesture {
                selectCar(car)
            }
            .swipeActions(edge: .leading) {
                reserveCarAction(for: car)
            }
            .swipeActions {
                deleteCarAction(for: car)
            }
        }
    }
    
    @ViewBuilder
    private func carDetails(for car: Car) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(car.model)
                    .font(.headline)
                Text("\(car.yearToStart)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Text("\(car.carType.capitalized) | \(car.fuelType.capitalized)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
    
    @ViewBuilder
    private func carStats(for car: Car) -> some View {
        VStack(alignment: .trailing) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                Text("\(car.carRating, specifier: "%.1f")")
            }
            Text("Riders: \(car.riders)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
    
    private func randomColor() -> Color {
        colors.randomElement() ?? .blue
    }
    
    private func selectCar(_ car: Car) {
        selectedCar = car
        showingAECarView = true
        isEdit = true
    }
    
    private func reserveCarAction(for car: Car) -> some View {
        Button(action: { reserveCar(car) }) {
            Label("", systemImage: "steeringwheel")
        }
        .tint(.purple)
    }
    
    private func deleteCarAction(for car: Car) -> some View {
        Button(role: .destructive, action: { deleteCar(car) }) {
            Image(systemName: "trash")
        }
    }
    
    private func fetchCars() {
        viewModel.fetchData(from: "cars", as: [Car].self) { result in
            if case .success(let cars) = result {
                viewModel.cars = cars
            }
        }
    }
    
    private func reserveCar(_ car: Car) {
        guard let index = viewModel.cars.firstIndex(where: { $0.id == car.id }) else { return }
        var editedCar = viewModel.cars[index]
        editedCar.reserve += 1
        
        viewModel.updateEntity(editedCar, at: "cars", id: car.id) { result in
            if case .success = result {
                viewModel.loadAllData()
            }
        }
        
        // here user's id need to put
        if let user = user {
            let newRide = Ride(user_id: user.id, car_id: car.id, ride_duration: 10, distance: 100, ride_cost: 100)
            // , to: "rides"
            viewModel.addCar(newRide) { result in
                if case .failure(let error) = result {
                    print("Error adding ride: \(error)")
                }
            }
        } else {
            let newRide = Ride(user_id: "S21145976p", car_id: car.id, ride_duration: 10, distance: 100, ride_cost: 100)
            // , to: "rides"
            //
            
            viewModel.sendRideData(newRide)
            
        
            
            //
//            viewModel.addCar(newRide) { result in
//                if case .failure(let error) = result {
//                    print("Error adding ride: \(error)")
//                }
//            }
        }
    }
    
    private func deleteCar(_ car: Car) {
        viewModel.deleteData(at: "cars", id: car.id) { result in
            if case .success = result {
                viewModel.loadAllData()
            }
        }
    }
}

#Preview {
    @Previewable var viewModel = APIClient()
    CarsListView(viewModel: viewModel)
}
