//
//  MainVIew.swift
//  RZBD
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 14.12.2024.
//

import Foundation
import SwiftUI

struct MainView: View {
    @State var showUserCreation = false
    
    var body: some View {

        
        NavigationStack {
            VStack {
                Spacer()
                NavigationLink(destination: AdminFlowView()) {
                    Text("Login as Admin")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(width: 250, height: 100)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                
                //                NavigationLink(destination: UserFlowView(id: "q13514597E")) {
                //                    Text("Login as User")
                //                        .font(.title)
                //                        .fontWeight(.bold)
                //                        .frame(width: 250, height: 100)
                //                        .background(Color.black)
                //                        .foregroundColor(.white)
                //                        .cornerRadius(15)
                //                }
                
                Button(action: {
                    showUserCreation = true
                }) {
                    Text("Login as User")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                
                // NavigationLink для перехода к UserCreationView
                NavigationLink(
                    destination: AddUserView(viewModel: APIClient()),
                    isActive: $showUserCreation
                ) {
                    EmptyView()
                }
            
                
                Spacer()
            }
        }
    }
}

#Preview {
    MainView()
}
