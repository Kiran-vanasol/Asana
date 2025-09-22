//
//  WorkoutPlayerView.swift
//  Asana
//
//  Created by Kiran T C on 12/09/25.
//

import SwiftUI

struct WorkoutPlayerView: View {
    @ObservedObject var vm: WorkoutViewModel
    @State private var goToCompleted = false
    @StateObject private var streakVM: StreakViewModel
    
    init(vm: WorkoutViewModel) {
        self.vm = vm
        _streakVM = StateObject(wrappedValue: StreakViewModel(workoutId: vm.workoutId))
    }

    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()

            VStack(spacing: 20) {
                // (Removed custom back HStack here — we use system back button)
                if vm.isPoseIntroActive, vm.currentIndex < vm.poses.count {
                        let pose = vm.poses[vm.currentIndex]
                        HStack(spacing: 16) {
                            if let localImage = UIImage(named: pose.name) {
                                Image(uiImage: localImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            } else {
                                AsyncImage(url: URL(string: pose.imageURL)) { img in
                                    img.resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                } placeholder: {
                                    ProgressView()
                                }
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Get Ready")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(pose.name)
                                    .font(.headline)
                                Text("\(vm.poseIntroCountdown)")
                                    .font(.headline)
                                    .foregroundColor(.orange)
                            }

                            Spacer()
                        }
                        .padding()
                        .background(.white)
                        .cornerRadius(16)
                        .shadow(radius: 4)
                        .padding(.horizontal, 20)
                    }
                
                


//                Spacer()

                if vm.currentIndex < vm.poses.count {
                    let pose = vm.poses[vm.currentIndex]

                    ZStack {
                        // Circular progress
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 6)
                        if !vm.isPoseIntroActive {
                            Circle()
                                .trim(from: 0, to: progress)
                                .stroke(Color(hex: "#EB784E") ?? .orange,
                                        style: StrokeStyle(lineWidth: 6, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                                .animation(.linear(duration: 1), value: vm.timeRemaining)
                        }
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
        // ← Use native system nav bar & back button
        .navigationTitle(vm.workoutType)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // center title styled like other screens
            ToolbarItem(placement: .principal) {
                Text("")
                    .font(.system(size: 24, weight: .bold, design: .serif))
                    .foregroundColor(Color(hex: "#EB784E"))
            }
            // optional trailing menu (if you want one)
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // menu action
                } label: {
                    Image(systemName: "line.horizontal.3")
                        .foregroundColor(Color(hex: "#171717"))
                }
            }
        }
        // If user leaves the view before finishing, finish the workout
        .onDisappear {
            // Only end workout if it wasn't already finished (avoids double-complete)
            if !vm.isWorkoutFinished {
                vm.finishWorkout()
            }
        }
        .navigationDestination(isPresented: $goToCompleted) {
            WorkoutCompletedView(streakVM: streakVM)
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

// CircleButton unchanged
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
