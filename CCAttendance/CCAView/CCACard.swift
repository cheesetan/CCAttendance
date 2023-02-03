//
//  CCACard.swift
//  CCAttendance
//
//  Created by Tristan on 31/01/2023.
//

import SwiftUI

struct CCACard: View {
    @State var backDegree = 0.0
    @State var frontDegree = 90.0
    @State var isFlipped = false
    @State var remoteFlip = false
    
    let width : CGFloat = 200
    let height : CGFloat = 250
    let durationAndDelay: CGFloat = 0.22
    
    //MARK: Flip Card Function
    func flipCard () {
        isFlipped = !isFlipped
        if isFlipped {
            withAnimation(.linear(duration: durationAndDelay)) {
                backDegree = -90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                frontDegree = 0
            }
        } else {
            withAnimation(.linear(duration: durationAndDelay)) {
                frontDegree = 90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                backDegree = 0
            }
        }
    }
    //MARK: View Body
    var body: some View {
        ZStack {
            CCACardBack(degree: $frontDegree, remoteFlip: $remoteFlip)
            CCACardFront(degree: $backDegree, remoteFlip: $remoteFlip)
        }
        .onChange(of: remoteFlip) { newValue in
            flipCard()
        }
    }
}

struct CCACardFront: View {
    
    @Binding var degree : Double
    @Binding var remoteFlip : Bool
    
    var body: some View {
        VStack {
            
            HStack {
                Button {
                    
                } label: {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "qrcode.viewfinder")
                                .font(.title2)
                            Spacer()
                        }
                        Spacer()
                    }
                }
                .buttonStyle(.plain)
                .background(Color.purple.opacity(0.3))
                .cornerRadius(16)
                .padding(.horizontal, 1)
                
                Button {
                    remoteFlip.toggle()
                } label: {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "megaphone")
                                .font(.title2)
                            Spacer()
                        }
                        Spacer()
                    }
                }
                .buttonStyle(.plain)
                .background(Color.purple.opacity(0.3))
                .cornerRadius(16)
                .padding(.horizontal, 1)
                
                Button {
                    
                } label: {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "calendar.day.timeline.right")
                                .font(.title2)
                            Spacer()
                        }
                        Spacer()
                    }
                }
                .buttonStyle(.plain)
                .background(Color.purple.opacity(0.3))
                .cornerRadius(16)
                .padding(.horizontal, 1)

            }
            .padding(.horizontal)
            
            Spacer()
            
            Divider()
            
            HStack {
                VStack(alignment:.leading) {
                    Text("Next CCA: 8 Feb 2023")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.top)
                    HStack {
                        Text("Astronomy Club")
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundColor(.primary)
                            .lineLimit(2)
                        
                        
                        Image(systemName: "globe.asia.australia.fill")
                            .fontWeight(.bold)
                            .font(.title)
                        
                        Spacer()
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(1...4, id: \.self) { value in
                                teacherCard(teacher: "Mr Tan Hoe Teck")
                            }
                        }
                    }
                    
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.bottom)
            
        }
        .frame(width: UIScreen.main.bounds.width - 75, height: UIScreen.main.bounds.width - 75, alignment: .center)
        .padding(.vertical)
        .background(.purple.opacity(0.5))
        .cornerRadius(32)
//        .overlay(
//            RoundedRectangle(cornerRadius: 32)
//                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
//        )
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
    }
}

struct CCACardBack: View {
    
    @Binding var degree : Double
    @Binding var remoteFlip : Bool
    
    var body: some View {
        VStack {
            List {
                Section(header:
                            HStack {
                    Text("Reminders")
                        .fontWeight(.bold)
                        .font(.subheadline)
                    Spacer()
                    Button {
                        remoteFlip.toggle()
                    } label: {
                        Image(systemName: "arrow.left.arrow.right")
                    }
                }
                ) {
                    ForEach(1...8, id: \.self) { value in
                        Text("Reminder")
                    }
                    .listRowBackground(Color.purple.opacity(0.3))
                }
            }
            .listRowBackground(Color.purple.opacity(0.3))
            .scrollContentBackground(.hidden)
            .listStyle(.insetGrouped)
            .scrollIndicators(.hidden)
        }
        .frame(width: UIScreen.main.bounds.width - 75, height: UIScreen.main.bounds.width - 75, alignment: .center)
        .padding(.vertical)
        .background(.purple.opacity(0.5))
        .cornerRadius(32)
//        .overlay(
//            RoundedRectangle(cornerRadius: 32)
//                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
//        )
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
    }
}

struct teacherCard: View {
    
    let teacher: String
    
    var body: some View {
        VStack {
            Text(teacher.uppercased())
                .foregroundColor(.primary)
                .font(.caption)
                .fontWeight(.bold)
                .padding(5)
                .background(.bar)
                .cornerRadius(6)
        }
    }
}

struct CCACard_Previews: PreviewProvider {
    static var previews: some View {
        CCACard()
    }
}
