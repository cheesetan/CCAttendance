//
//  Authentication.swift
//  CCAttendance
//
//  Created by Tristan on 25/01/2023.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct Authentication: View {
    
    @State var email = String()
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("welcome - placeholder")
                .fontWeight(.bold)
                .font(.title3)
            
            emailField
            
            Spacer()
        }
    }
    
    
    var emailField: some View {
        VStack {
            TextField("", text: $email)
        }
    }
}

struct Authentication_Previews: PreviewProvider {
    static var previews: some View {
        Authentication()
    }
}
