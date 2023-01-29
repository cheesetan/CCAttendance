//
//  ContentView.swift
//  CCAttendance
//
//  Created by Tristan on 25/01/2023.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("isLoggedIn", store: .standard) var isLoggedIn = false
    
    var body: some View {
        if isLoggedIn {
            CCAView()
        } else {
            LogInView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
