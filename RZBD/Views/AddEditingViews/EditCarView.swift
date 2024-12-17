//
//  EditCarView.swift
//  RZBD
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 15.12.2024.
//

import Foundation
import SwiftUI

struct EditCarView: View {
    @ObservedObject var viewModel: APIClient
    @Binding var selectedCar: Car?

    @Environment(\.presentationMode) var presentationMode
    @State private var model = ""
    @State private var carType = ""
    @State private var fuelType = ""
    @State private var carRating = ""
    @State private var yearToStart = ""
    @State private var riders = ""
    @State private var id = ""

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
            .onAppear {
                if let selectedCar = selectedCar {
                    model = selectedCar.model
                    carType = selectedCar.carType
                    fuelType = selectedCar.fuelType
                    carRating = String(selectedCar.carRating)
                    yearToStart = String(selectedCar.yearToStart)
                    riders = String(selectedCar.riders)
                    id = selectedCar.id
                }
            }
            .navigationTitle("Edit Car")
            .navigationBarItems(trailing: Button("Save changes") {
                var editedCar = Car(model: model, carType: carType, fuelType: fuelType, carRating: Float(carRating) ?? 5.0,  yearToStart: Int(yearToStart) ?? 0, yearToWork: 0)
                editedCar.id = id
                viewModel.updateEntity(editedCar, at: "cars", id: editedCar.id) { result in
                    switch result {
                    case .success:
                        print("Updated")
                    case .failure:
                        print("Error")
                    }
                }
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}


