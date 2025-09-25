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
    @State private var selectedPose: APIPose?       
    @State private var showInfoSheet = false


    var body: some View {
        VStack(spacing: 0) {
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
                            Button {
                             selectedPose = pose
                                showInfoSheet = true
                            } label: {
                                HStack(spacing: 16) {
                                    CachedAsyncImage(url: URL(string: pose.imageURL)) { image in
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
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                }
            }

            // Start Button
            NavigationLink {
                WorkoutIntroView(
                    vm: WorkoutViewModel(
                        poses: viewModel.poses,
                        workoutType: "BackPain",
                        workoutId: "BackPain01"
                    )
                )
            } label: {
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
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Centered bold orange title like the 2nd screenshot
            ToolbarItem(placement: .principal) {
                Text("Back Pain")
                    .font(.system(size: 24, weight: .bold, design: .serif))
                    .foregroundColor(Color(hex: "#EB784E"))
            }

            // Optional menu button on the right
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // add menu action here
                } label: {
                    Image(systemName: "line.horizontal.3")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
        }
        .task {
            await viewModel.fetchPoses(for: "BackPain")
        }
        .sheet(isPresented: $showInfoSheet) {
            if let pose = selectedPose {
                PoseInfoSheet(
                    pose: APIPose(
                        id: pose.id,
                        name: pose.name,
                        imageURL: pose.imageURL,
                        category: "Back Pain",
                        benefits: pose.benefits,
                        caution: pose.caution,
                        howToPrepare: pose.howToPrepare
                    ),
                    onDismiss: {
                        showInfoSheet = false
                    }
                )
            }
        }
    }
}
