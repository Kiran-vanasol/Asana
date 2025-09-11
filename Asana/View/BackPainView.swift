//
//  BackPainView.swift
//  Asana
//
//  Created by Kiran T C on 10/09/25.
//

import SwiftUI

struct BackPainView: View {
    var title = "Yoga for Back Pain"
    @StateObject private var viewModel = BackPainViewModel()
    @Environment(\.dismiss) private var dismiss


    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    // TODO: Handle dismiss
                    dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .font(.title2)
                        .foregroundColor(Color(hex: "#171717"))
                }
                
                Spacer()
                
                Text("Back Pain")
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .foregroundColor(Color(hex: "#EB784E"))
                
                Spacer()
                
                Button(action: {
                    // TODO: Menu action
                }) {
                    Image(systemName: "line.horizontal.3")
                        .font(.title2)
                        .foregroundColor(Color(hex: "#171717"))
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            // Poses List
            if viewModel.isLoading {
                Spacer()
                ProgressView("Loading poses...")
                Spacer()
            } else if let error = viewModel.errorMessage {
                Spacer()
                Text("Error: \(error)")
                    .foregroundColor(.red)
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(viewModel.poses) { pose in
                            HStack(spacing: 16) {
                                AsyncImage(url: URL(string: pose.imageURL)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 60, height: 60)
                                }

                                Text(pose.name)
                                    .font(.system(size: 20, weight: .semibold, design: .serif))
                                    .foregroundColor(Color(hex: "#171717"))

                                Spacer()
                            }
                            .padding(.horizontal)
                            .onAppear {
                                print("Loading Pose: \(pose.name), URL: \(pose.imageURL)")
                            }
                        }
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                }
            }

            // Start Button
            Button(action: {
                print("Starting flow: \(title)")
            }) {
                Text("Let’s Start")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color(hex: "#EB784E"))
                    .cornerRadius(20)
                    .padding(.horizontal)
            }
            .padding(.bottom, 12)
        }
        .background(Color(hex: "#EAF2F2").ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .task {
            await viewModel.fetchPoses(for: "BackPain")
        }
    }
}
