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

    @State var index = 1
    @AppStorage("isLoggedIn", store: .standard) var isLoggedIn = false

    var body: some View {
        NavigationStack {
                LazyHStack(alignment: .center, spacing: 30) {
                    ForEach(1...3, id: \.self) { value in
                        CCACard()
                    }
                }
                .modifier(ScrollingHStackModifier(items: 3, itemWidth: UIScreen.main.bounds.width - 75, itemSpacing: 30))

            .navigationTitle("CCAttendance")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(role: .destructive) {
                        do {
                            try Auth.auth().signOut()
                            isLoggedIn = false
                        } catch {
                            print("an error occurred while trying to sign out")
                        }
                    } label: {
                        Text("Sign Out")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}

struct CCAView_Previews: PreviewProvider {
    static var previews: some View {
        CCAView()
    }
}
