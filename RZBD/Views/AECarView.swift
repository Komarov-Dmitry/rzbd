//
//  AECarView.swift
//  RZBD
//
//  Created by Дмитрий Комаров on 14.12.2024.
//

import Foundation
import SwiftUI

struct NewCarView: View {
    @ObservedObject var viewModel: CarsViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isEdit = false
    @State private var model = ""
    @State private var carType = ""
    @State private var fuelType = ""
    @State private var carRating = ""
    @State private var yearToStart = ""
    @State private var yearToWork = ""
    @State private var riders = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Car Details")) {
                    TextField("Model", text: $model)
                    TextField("Car Type", text: $carType)
                    TextField("Fuel Type", text: $fuelType)
                    TextField("Rating", text: $carRating)
                    TextField("Year To Start", text: $yearToStart)
                    TextField("Year To Work", text: $yearToWork)
                    TextField("Riders", text: $riders)
                }
                .onAppear {
//                    if !isEdit, let car = viewModel.selectedCar {
//                        // Populate fields with the selected car's details
//                        model = car.model
//                        carType = car.carType
//                        fuelType = car.fuelType
//                        carRating = car.carRating
//                        yearToStart = "\(car.yearToStart)"
//                        yearToWork = "\(car.yearToWork)"
//                        riders = "\(car.riders)"
//                    }
                }
            }
            .navigationTitle(isEdit ? "Edit Car" : "Add New Car")
            .navigationBarItems(trailing: Button("Save") {
//                saveCar()
            })
        }
    }
    
//    private func saveCar() {
//        guard let yearStart = Int(yearToStart), let yearWork = Int(yearToWork), let ridersCount = Int(riders) else { return }
//        if isEdit, let selectedCar = viewModel.selectedCar {
//            // Edit existing car
//            viewModel.editCar(id: selectedCar.id, model: model, carType: carType, fuelType: fuelType, carRating: carRating, yearToStart: yearStart, yearToWork: yearWork, riders: ridersCount)
//        } else {
//            // Add new car
//            viewModel.addCar(model: model, carType: carType, fuelType: fuelType, carRating: carRating, yearToStart: yearStart, yearToWork: yearWork, riders: ridersCount)
//        }
//        presentationMode.wrappedValue.dismiss()
//    }
}
