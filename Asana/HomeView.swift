//
//  HomeView.swift
//  Asana
//
//  Created by Kiran T C on 04/09/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color(hex: "#EAF2F2") // background color
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                
                // Top Header
                HStack {
                    Text("Āsanas")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(Color(hex: "#171717"))
                    
                    Spacer()
                    
                    // Profile Image
                    Image("profile") // Add your profile image in Assets
                        .resizable()
                        .scaledToFill()
                        .frame(width: 38, height: 38)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 1.5)
                        )
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                Spacer()
                
                // Āsanas Section
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 14) {
                        ForEach(["YogaForBackPain", "YogaForNeckPain", "YogaForPosture"], id: \.self) { img in
                            Image(img)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 240, height: 260) // ⬅️ Wider, shorter cards
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 1, y: 2)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Meditate Section
                Text("Meditate")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "#171717"))
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 14) {
                        ForEach(["EarthMelody", "InnerEchoes", "WavesOfBliss"], id: \.self) { img in
                            Image(img)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 240, height: 260) // same as Asanas
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 1, y: 2)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

// Helper initializer for hex colors
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}
