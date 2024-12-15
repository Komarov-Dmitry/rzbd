//
//  AECarView.swift
//  RZBD
//
//  Created by Дмитрий Комаров on 14.12.2024.
//

import Foundation
import SwiftUI

struct AddCarView: View {
    @ObservedObject var viewModel: APIClient


    @Environment(\.presentationMode) var presentationMode
    @State private var model = ""
    @State private var carType = ""
    @State private var fuelType = ""
    @State private var carRating = ""
    @State private var yearToStart = ""
    @State private var riders = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Model | Car Type")) {
                    TextField("Model", text: $model)
                    TextField("Car Type", text: $carType)
                }
                Section(header: Text("Fuel Type | Rating")) {
                    TextField("Fuel Type", text: $fuelType)
                    TextField("Rating", text: $carRating)
                }
                Section(header: Text("Year To Start | Riders")) {
                    TextField("Year To Start", text: $yearToStart)
                    TextField("Riders", text: $riders)
                }
            }
            .navigationTitle("Adding Car")
            .navigationBarItems(trailing: Button("Add") {
               addingCar()
            })
        }
    }

    
    private func addingCar() {
        let newCar = Car(
            model: model,
            carType: carType,
            fuelType: fuelType,
            carRating: Float(carRating) ?? 5.0,
            yearToStart: Int(yearToStart) ?? 0,
            yearToWork: 0,
            riders: Int(riders) ?? 0
        )
        // Сохранение через ViewModel
        viewModel.addData(newCar, to: "cars") { result in
            switch result {
            case .success:
                print("Car added successfully")
            case .failure(let error):
                print("Error adding car: \(error)")
            }
        }
        presentationMode.wrappedValue.dismiss() // Закрыть окно
    }
}


