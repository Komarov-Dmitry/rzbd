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
        Spacer()
        VStack {
            Button("Login as Admin") {
                print("Admin is log in")
            }
            .font(.title)
            .fontWeight(.bold)
            .frame(width: 250, height: 100)
            .background(Color.black)
            .cornerRadius(15)
            Button("Login as User") {
                print("User is log in")
            }
            .font(.title)
            .fontWeight(.bold)
            .frame(width: 250, height: 100)
            .background(Color.black)
            .cornerRadius(15)
        }
        Spacer()
    }
}

#Preview() {
    MainView()
}
