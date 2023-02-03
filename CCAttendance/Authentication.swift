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

struct RegisterView: View {
    
    let generator = UIImpactFeedbackGenerator(style: .medium)
    let generator2 = UINotificationFeedbackGenerator()
    
    @State var email = String()
    @State var password = String()
    @State var passwordConfirmation = String()
    
    @State var isSecured = true
    @State var isSecured2 = true
    
    @State var emailNotValid = false
    @State var showVerificationAlert = false
    
    @State var authenticationIsRegister = true
    
    var body: some View {
        if authenticationIsRegister == true {
            VStack {
                Spacer()
                Spacer()
                
                textTitle
                
                emailField
                
                passwordField
                
                confirmPasswordField
                
                Spacer()
                
                registerButton
                    .padding(.top)
                
                Spacer()
                
                switchAuthenticationButton
                    .padding(.bottom)
                
            }
            .padding(.horizontal)
        } else {
            LogInView()
        }
    }
    
    
    var textTitle: some View {
        HStack {
            Text("Welcome to CCAttendance!")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .multilineTextAlignment(.leading)
            Spacer()
        }
    }
    
    
    var emailField: some View {
        VStack {
//            HStack {
//                Text("SST Email")
//                    .fontWeight(.bold)
//                    .font(.caption)
//                Spacer()
//            }
            
            TextField("SST Email", text: $email)
                .padding(20)
                .background(.thinMaterial)
                .cornerRadius(10)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: emailNotValid == true ? 2 : 0).foregroundColor(.red))
            
            if !email.isEmpty {
                if email.localizedStandardContains(".ssts.edu.sg") || email.localizedStandardContains("@sst.edu.sg") {
                    HStack {
                        Spacer()
                            .onAppear {
                                emailNotValid = false
                            }
                    }
                } else {
                    Text("This is not a valid SST Email")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(Color.red)
                        .onAppear {
                            emailNotValid = true
                        }
                }
            } else {
                HStack {
                    Spacer()
                        .onAppear {
                            emailNotValid = false
                        }
                }
            }
        }
    }
    
    
    var passwordField: some View {
        VStack {
//            HStack {
//                Text("Password")
//                    .fontWeight(.bold)
//                    .font(.caption)
//                Spacer()
//            }
            
            ZStack(alignment: .trailing) {
                Group {
                    if isSecured {
                        SecureField("Password", text: $password)
                            .padding(20)
                            .background(.thinMaterial)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: password.count < 6 && password.count > 0 ? 2 : 0).foregroundColor(.red))
                    } else {
                        TextField("Password", text: $password)
                            .padding(20)
                            .background(.thinMaterial)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: password.count < 6 && password.count > 0 ? 2 : 0).foregroundColor(.red))
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
            
            if !password.isEmpty {
                if password.count < 6 {
                    Text("Password has to contain at least 6 characters")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(Color.red)
                }
            }
        }
    }
    
    
    var confirmPasswordField: some View {
        VStack {
//            HStack {
//                Text("Confirm Password")
//                    .fontWeight(.bold)
//                    .font(.caption)
//                Spacer()
//            }
            
            ZStack(alignment: .trailing) {
                Group {
                    if isSecured2 {
                        SecureField("Confirm your Password", text: $passwordConfirmation)
                            .padding(20)
                            .background(.thinMaterial)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: passwordConfirmation != password ? 2 : 0).foregroundColor(.red))
                    } else {
                        TextField("Confirm your Password", text: $passwordConfirmation)
                            .padding(20)
                            .background(.thinMaterial)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: passwordConfirmation != password ? 2 : 0).foregroundColor(.red))
                    }
                    Spacer()
                    Button(action: {
                        isSecured2.toggle()
                        generator.impactOccurred(intensity: 0.5)
                    }) {
                        Image(systemName: self.isSecured2 ? "eye.slash" : "eye")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 23, height: 23)
                            .accentColor(.gray)
                            .padding()
                            .padding(.trailing, 3)
                    }
                    
                }
            }
            if passwordConfirmation != password {
                Text("Your passwords dont match")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(Color.red)
            }
        }
    }
    
    
    var registerButton: some View {
        VStack {
            Button {
                if !email.isEmpty && email != " " && !password.isEmpty && password != " " && passwordConfirmation == password && password.count >= 6 {
                    Firebase.Auth.auth().createUser(withEmail: email, password: password, completion: { result, error in
                        guard error == nil else {
                            print("account creation failed")
                            generator2.notificationOccurred(.error)
                            return
                        }
                        
                        let user = Auth.auth().currentUser
                        
                        Firestore.firestore().collection("users").document(user!.uid).setData([
                            "email": user!.email as Any,
                            "email-verified": user!.isEmailVerified,
                            "password": password,
                            "UID": user!.uid
                        ])
                        
                        Auth.auth().currentUser?.sendEmailVerification { error in
                            // ...
                        }
                        
                        do {
                            try Firebase.Auth.auth().signOut()
                        } catch {
                            print("An error has occurred while trying to sign out.")
                        }
                        
                        generator2.notificationOccurred(.success)
                        
                        showVerificationAlert = true
                    })
                }
            } label: {
                HStack {
                    Text("Register")
                        .fontWeight(.bold)
                    Image(systemName: "person.crop.circle.badge.plus")
                        .fontWeight(.bold)
                }
                .frame(width: 200, height: 60)
                .background(.thinMaterial)
                .cornerRadius(150)
            }
            .disabled(email.isEmpty || email == " " || password.isEmpty || password == " " || passwordConfirmation != password || password.count < 6)
            .alert("Email Verification", isPresented: $showVerificationAlert, actions: {
                Button("OK", role: .cancel) {
                    email = ""
                    password = ""
                    passwordConfirmation = ""
                }
            }, message: {
                Text("Click the link sent to your SST Email to complete registration. Check your spam/junk folder if you cant find the email. Log in once you've verified your email.")
            })
        }
    }
    
    
    var switchAuthenticationButton: some View {
        VStack {
            Button {
                authenticationIsRegister = false
                generator.impactOccurred(intensity: 0.7)
            } label: {
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.primary)
                    Text("Log In!")
                        .foregroundColor(.blue)
                }
                .font(.headline)
                .fontWeight(.bold)
            }
            .buttonStyle(.plain)
        }
    }
}



struct LogInView: View {
    
    let generator = UIImpactFeedbackGenerator(style: .medium)
    let generator2 = UINotificationFeedbackGenerator()
    
    @State var email = String()
    @State var password = String()
    
    @State var isSecured = true
    
    @State var showVerificationAlert = false
    @State var authenticationIsLogIn = true
    
    @AppStorage("isLoggedIn", store: .standard) var isLoggedIn = false
    @AppStorage("userEmail", store: .standard) var userEmail = ""
    @AppStorage("userUID", store: .standard) var userUID = ""
    @AppStorage("userPassword", store: .standard) var userPassword = ""
    
    var body: some View {
        if authenticationIsLogIn == true {
            VStack(spacing: 15) {
                Spacer()
                Spacer()
                
                textTitle
                
                emailField
                
                passwordField
                
                Spacer()
                
                logInButton
                
                Spacer()
                
                switchAuthenticationButton
                    .padding(.bottom)
                
            }
            .padding(.horizontal)
        } else {
            RegisterView()
        }
    }
    
    
    var textTitle: some View {
        HStack {
            Text("Welcome back to CCAttendance!")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .multilineTextAlignment(.leading)
            Spacer()
        }
    }
    
    
    var emailField: some View {
        VStack {
//            HStack {
//                Text("SST Email")
//                    .fontWeight(.bold)
//                    .font(.caption)
//                Spacer()
//            }
            
            TextField("SST Email", text: $email)
                .padding(20)
                .background(.thinMaterial)
                .cornerRadius(10)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
        }
    }
    
    
    var passwordField: some View {
        VStack {
//            HStack {
//                Text("Password")
//                    .fontWeight(.bold)
//                    .font(.caption)
//                Spacer()
//            }
            
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
    
    
    var logInButton: some View {
        VStack {
            Button {
                Firebase.Auth.auth().signIn(withEmail: email, password: password, completion: { result, error in
                    guard error == nil else {
                        print("could not find account")
                        generator2.notificationOccurred(.error)
                        return
                    }
                    
                    if Auth.auth().currentUser?.isEmailVerified == true {
                        
                        let user = Auth.auth().currentUser
                        Firestore.firestore().collection("users").document(user!.uid).updateData([
                            "email-verified": true,
                        ]) { err in
                            if let err = err {
                                print("Error updating document: \(err)")
                            } else {
                                print("Document successfully updated")
                            }
                        }
                        
                        userEmail = (Auth.auth().currentUser?.email!)!
                        userPassword = password
                        isLoggedIn = true
                        userUID = Auth.auth().currentUser!.uid
                        
                        generator2.notificationOccurred(.success)
                    } else {
                        let user = Auth.auth().currentUser
                        Firestore.firestore().collection("users").document(user!.uid).updateData([
                            "email-verified": false,
                        ]) { err in
                            if let err = err {
                                print("Error updating document: \(err)")
                            } else {
                                print("Document successfully updated")
                            }
                        }
                        
                        generator2.notificationOccurred(.error)
                        
                        Auth.auth().currentUser?.sendEmailVerification { error in
                            // ...
                        }
                        
                        do {
                            try Firebase.Auth.auth().signOut()
                        } catch {
                            print("An error has occurred while trying to sign out.")
                        }
                        
                        showVerificationAlert = true
                    }
                    
//                    if (Auth.auth().currentUser != nil) {
//                        let query = Firestore.firestore().collection("users").whereField("email", isEqualTo: finalEmail)
//                        query.getDocuments() { (querySnapshot, err) in
//                            if let err = err {
//                                print("Error getting documents: \(err)")
//                            } else {
//                                for document in querySnapshot!.documents {
//                                    finalUsername = "\(document.get("username") ?? "UNKNOWNS")"
//                                    generator2.notificationOccurred(.success)
//                                    showingOnboarding = false
//                                    presentationMode.wrappedValue.dismiss()
//                                }
//                            }
//                        }
//                    }
                })
            } label: {
                HStack {
                    Text("Log In")
                        .fontWeight(.bold)
                    Image(systemName: "arrow.right")
                        .fontWeight(.bold)
                }
                .frame(width: 200, height: 60)
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(150)
            }
        }
        .alert("Verify your Email", isPresented: $showVerificationAlert, actions: {
            Button("OK", role: .cancel) {
                
            }
        }, message: {
            Text("Click the link sent to your SST Email to complete registration. Check your spam/junk folder if you cant find the email. Log in once you've verified your email.")
        })
    }
    
    
    var switchAuthenticationButton: some View {
        VStack {
            Button {
                authenticationIsLogIn = false
                generator.impactOccurred(intensity: 0.7)
            } label: {
                HStack {
                    Text("New to CCAttendance?")
                        .foregroundColor(.primary)
                    Text("Register!")
                        .foregroundColor(.blue)
                }
                .font(.headline)
                .fontWeight(.bold)
            }
            .buttonStyle(.plain)
        }
    }
}

struct Authentication_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
