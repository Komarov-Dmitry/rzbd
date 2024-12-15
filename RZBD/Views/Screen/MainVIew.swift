//
//  MainVIew.swift
//  RZBD
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 14.12.2024.
//

import Foundation
import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            Spacer()
            VStack {
                NavigationLink(destination: AdminFlowView()) {
                    Text("Login as Admin")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(width: 250, height: 100)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }

                NavigationLink(destination: UserFlowView()) {
                    Text("Login as User")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(width: 250, height: 100)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
            }
            Spacer()
        }
    }
}

#Preview {
    MainView()
}
