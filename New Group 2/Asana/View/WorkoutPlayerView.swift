//
//  WorkoutPlayerView.swift
//  Asana
//
//  Created by Kiran T C on 12/09/25.
//

import SwiftUI

struct WorkoutPlayerView: View {
    @ObservedObject var vm: WorkoutViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var goToCompleted = false

    var body: some View {
        ZStack {
            Color(.systemGray6) // background like Android
                .ignoresSafeArea()

            VStack(spacing: 40) {
                // Custom back button
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.horizontal)

                Spacer()

                if vm.currentIndex < vm.poses.count {
                    let pose = vm.poses[vm.currentIndex]

                    ZStack {
                        // Background ring
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 6)

                        // Animated timer progress ring
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(Color(hex: "#EB784E") ?? .orange,
                                    style: StrokeStyle(lineWidth: 6, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .animation(.linear(duration: 1), value: vm.timeRemaining)

                        // Pose image
                        if let localImage = UIImage(named: pose.name) {
                            Image(uiImage: localImage)
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .padding(6)
                        } else {
                            AsyncImage(url: URL(string: pose.imageURL)) { img in
                                img.resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .padding(24)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                    .frame(width: 350, height: 350)

                    // Pose name + info icon
                    HStack(spacing: 6) {
                        Text(pose.name)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)

                        Image(systemName: "info.circle")
                            .foregroundColor(.gray)
                    }

                    // Countdown timer (just number like Android)
                    Text("\(vm.timeRemaining)")
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                        .foregroundColor(.black)

                    // Control buttons
                    HStack(spacing: 60) {
                        CircleButton(icon: "backward.fill") {
                            if vm.currentIndex > 0 {
                                vm.currentIndex -= 1
                                vm.timeRemaining = 40
                            }
                        }

                        Button(action: {
                                vm.togglePauseResume()
                            }) {
                                Image(systemName: vm.isPaused ? "play.fill" : "pause.fill")
                                    .font(.system(size: 36))
                                    .foregroundColor(.white)
                                    .frame(width: 70, height: 70)
                                    .background(Circle().fill(Color(hex: "#EB784E") ?? .orange))
                            }

                        CircleButton(icon: "forward.fill") {
                            vm.advancePose()
                        }
                    }
                }

                Spacer()
            }
            .padding(.vertical, 20)
        }
        .navigationBarBackButtonHidden(true) // hide default back
        .navigationDestination(isPresented: $goToCompleted) {
            WorkoutCompletedView()
        }
        .onChange(of: vm.isWorkoutFinished) { finished in
            if finished { goToCompleted = true }
        }
        .onAppear {
            vm.startWorkout()
        }
    }

    /// Progress fraction (0 → 1)
    private var progress: CGFloat {
        guard vm.timeRemaining > 0 else { return 0 }
        return CGFloat(vm.timeRemaining) / 40.0
    }
}

/// Reusable circular button
struct CircleButton: View {
    var icon: String
    var size: CGFloat = 60
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size == 70 ? 36 : 28))
                .foregroundColor(.white)
                .frame(width: size, height: size)
                .background(Circle().fill(Color(hex: "#EB784E") ?? .orange))
        }
    }
}
