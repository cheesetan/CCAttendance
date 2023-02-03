//
//  QRScannerView.swift
//  CCAttendance
//
//  Created by Tristan on 03/02/2023.
//

import SwiftUI
import Firebase
import FirebaseAuth
import CodeScanner


struct QRScannerView: View {
    
    @Binding var degree : Double
    @Binding var remoteFlip : Bool
    @Binding var isFlipped : Bool
    
    let generator = UIImpactFeedbackGenerator(style: .medium)
    let generator2 = UINotificationFeedbackGenerator()
    
    @State private var isTorchOn = false
    
    @Environment(\.presentationMode) var presentationMode
    
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    var body: some View {
        NavigationStack {
            VStack {
                if isFlipped {
                    CodeScannerView(codeTypes: [.aztec], scanMode: .oncePerCode, simulatedData: "ccAttendanceApproved87654321", shouldVibrateOnSuccess: false, isTorchOn: isTorchOn, completion: handleScanResult)
                        .overlay(
                            Button {
                                remoteFlip.toggle()
                            } label: {
                                Text(" ")
                            }
                                .buttonStyle(.plain)
                            ,alignment: .center
                        )
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 75, height: UIScreen.main.bounds.width - 75, alignment: .center)
        .cornerRadius(32)
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
        .onDisappear {
            remoteFlip.toggle()
        }
    }
    
    func handleScanResult(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let result):
            let qrValue = result.string
            print(result)
            print(qrValue)
            if qrValue.contains("ccAttendanceApproved") {
                let qrValueNew = qrValue.replacingOccurrences(of: "ccAttendanceApproved", with: "", options: NSString.CompareOptions.literal, range: nil)
                
                print("new qrvalue: \(qrValueNew)")
                
                remoteFlip.toggle()

//                Firestore.firestore().collection("users").whereField("connectCode", isEqualTo: qrValueNew).getDocuments() { (snapshot, error) in
//                    if let error = error {
//                        print("error getting documents! \(error)")
//                        generator2.notificationOccurred(.error)
//                    } else {
//                        for document in snapshot!.documents {
//                            db.collection("users").document(document.documentID).getDocument { (document, error) in
//                                guard error == nil else {
//                                    print("error", error ?? "")
//                                    return
//                                }
//
//                                if let document = document, document.exists {
//                                    let data = document.data()
//                                    if let data = data {
//                                        print("data", data)
//
//                                    }
//                                }
//
//                            }
//                        }
//                    }
//                }
                
            } else {
                generator2.notificationOccurred(.error)
            }
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
}

//struct QRScannerView_Previews: PreviewProvider {
//    static var previews: some View {
//        QRScannerView()
//    }
//}
