//
//  Authentication.swift
//  CCAttendance
//
//  Created by Tristan on 25/01/2023.
//

import SwiftUI
import SwiftUI
import Firebase
import FirebaseAuth

struct Authentication: View {
    
    let generator = UIImpactFeedbackGenerator(style: .medium)
    let generator2 = UINotificationFeedbackGenerator()
    
    @State var email = String()
    @State var password = String()
    @State var isSecured = true
    
    var body: some View {
        VStack(spacing: 15) {
            Spacer()
            
            HStack {
                Text("Sign in to CCAttendance")
                    .fontWeight(.bold)
                    .font(.title2)
                Spacer()
            }
            
            emailField
            
            passwordField
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
    
    var emailField: some View {
        VStack {
            HStack {
                Text("SST Email")
                    .fontWeight(.bold)
                    .font(.caption)
                Spacer()
            }
            
            TextField("SST Email", text: $email)
                .padding(20)
                .background(.thinMaterial)
                .cornerRadius(10)
                .textInputAutocapitalization(.never)
        }
    }
    
    var passwordField: some View {
        VStack {
            HStack {
                Text("Password")
                    .fontWeight(.bold)
                    .font(.caption)
                Spacer()
            }
            
            ZStack(alignment: .trailing) {
                Group {
                    if isSecured {
                        SecureField("Password", text: $password)
                            .padding(20)
                            .background(.thinMaterial)
                            .cornerRadius(10)
                    } else {
                        TextField("Password", text: $password)
                            .padding(20)
                            .background(.thinMaterial)
                            .cornerRadius(10)
                    }
                    Spacer()
                    Button(action: {
                        isSecured.toggle()
                        generator.impactOccurred(intensity: 0.5)
                    }) {
                        Image(systemName: self.isSecured ? "eye.slash" : "eye")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 23, height: 23)
                            .accentColor(.gray)
                            .padding()
                            .padding(.trailing, 3)
                    }
                    
                }
            }
        }
    }
}

struct Authentication_Previews: PreviewProvider {
    static var previews: some View {
        Authentication()
    }
}
