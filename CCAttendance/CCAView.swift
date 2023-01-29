//
//  CCAView.swift
//  CCAttendance
//
//  Created by Tristan on 29/01/2023.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct CCAView: View {
    
    @AppStorage("isLoggedIn", store: .standard) var isLoggedIn = false
    
    var body: some View {
        VStack {
            Text("CCA View")
            Button(role: .destructive) {
                do {
                    try Auth.auth().signOut()
                    isLoggedIn = false
                } catch {
                    print("an error occurred while trying to sign out")
                }
            } label: {
                Text("Sign Out")
            }
        }
    }
}

struct CCAView_Previews: PreviewProvider {
    static var previews: some View {
        CCAView()
    }
}
