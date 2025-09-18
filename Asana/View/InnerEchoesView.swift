//
//  InnerEchoesView.swift
//  Asana
//
//  Created by Kiran T C on 16/09/25.
//

import SwiftUI

struct InnerEchoesView: View {
    var title = "Inner Echoes"
    @StateObject private var viewModel = BackPainViewModel()

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
                        workoutType: "InnerEchoes"
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
                Text("Inner Echoes")
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
            await viewModel.fetchPoses(for: "InnerEchoes")
        }
    }
}

