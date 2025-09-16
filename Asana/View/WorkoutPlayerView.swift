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
            Color(.systemGray6).ignoresSafeArea()

            VStack(spacing: 40) {
                // Back button
                HStack {
                    Button(action: {
                        vm.finishWorkout()
                        dismiss()
                    }) {
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
                        // Circular progress
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 6)

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

                        //  Overlay 5s popup
                        if vm.isPoseIntroActive {
                            VStack(spacing: 12) {
                                Text("Get Ready for")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                Text(pose.name)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("\(vm.poseIntroCountdown)")
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(.orange)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.ultraThinMaterial)
                            .cornerRadius(16)
                            .shadow(radius: 6)
                            .transition(.opacity)
                        }
                    }
                    .frame(width: 350, height: 350)

                    // Pose name
                    HStack(spacing: 6) {
                        Text(pose.name)
                            .font(.title2)
                            .fontWeight(.semibold)
                        Image(systemName: "info.circle")
                            .foregroundColor(.gray)
                    }

                    // Timer
                    if !vm.isPoseIntroActive {
                        Text("\(vm.timeRemaining)")
                            .font(.system(size: 44, weight: .bold, design: .rounded))
                    }

                    // Controls
                    HStack(spacing: 60) {
                        CircleButton(icon: "backward.fill") {
                            vm.goBackPose()
                        }
                        Button(action: { vm.togglePauseResume() }) {
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

            // Up Next popup
            if vm.showUpNext, let next = vm.upNextPose {
                VStack {
                    Spacer()
                    HStack(spacing: 16) {
                        if let localImage = UIImage(named: next.name) {
                            Image(uiImage: localImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else {
                            AsyncImage(url: URL(string: next.imageURL)) { img in
                                img.resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            } placeholder: {
                                ProgressView()
                            }
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Up Next")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(next.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                        }

                        Spacer()
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(16)
                    .shadow(radius: 4)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut, value: vm.showUpNext)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $goToCompleted) {
            WorkoutCompletedView()
        }
        .onChange(of: vm.isWorkoutFinished) { finished in
            if finished { goToCompleted = true }
        }
        .onAppear {
            if vm.currentIndex == 0 && vm.isIntroActive {
                vm.startIntro()
            }
        }
    }

    private var progress: CGFloat {
        guard vm.poseDuration > 0 else { return 0 }
        return CGFloat(vm.timeRemaining) / CGFloat(vm.poseDuration)
    }
}

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
