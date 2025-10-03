//
//  HomeView.swift
//  Asana
//
//  Created by Kiran T C on 04/09/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()

    var body: some View {
       
            ZStack {
                Color(hex: "#EAF2F2")
                    .ignoresSafeArea()

                if vm.isLoading {
                    ProgressView("Loading...")
                } else if let error = vm.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                } else {
                    VStack(alignment: .leading, spacing: 20) {
                        // Top Header
                        HStack {
                            Spacer()
                            Text("Āsanas")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(Color(hex: "#171717"))
                            Spacer()

                            NavigationLink(destination: ProfileView()) {
                                ProfileImageView()
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)

                        // Asanas Section
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 14) {
                                ForEach(vm.asanas) { item in
                                    AsanaNavigationLinks(item: item)
                                }
                            }
                            .padding(.horizontal)
                        }

                        // Meditate Section
                        Text("Meditate")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(Color(hex: "#171717"))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 15)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 14) {
                                ForEach(vm.meditate) { item in
                                    AsanaNavigationLinks(item: item)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, -60)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .task {
                await vm.fetchHomeData()
            }
        
    }
}
