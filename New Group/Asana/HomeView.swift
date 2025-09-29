//
//  HomeView.swift
//  Asana
//
//  Created by Kiran T C on 04/09/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {   // Wrap the whole view in a NavigationStack
            ZStack {
                Color(hex: "#EAF2F2")
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Top Header
                    HStack {
                        Spacer()
                        Text("Āsanas")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(Color(hex: "#171717"))
                        Spacer()
                        
                        // Profile Image (right aligned)
                        Image("profile")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 38, height: 38)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 1.5)
                            )
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    
                    // Āsanas Section
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(["YogaForBackPain", "YogaForNeckPain", "YogaForPosture"] , id: \.self) { img in
                                AsanaNavigationLinks(img: img)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Meditate Section
                    Text("Meditate")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(Color(hex: "#171717"))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 10)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(["EarthMelody", "InnerEchoes", "WavesOfBliss"], id: \.self) { img in
                                Image(img)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 240, height: 260)
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
}
