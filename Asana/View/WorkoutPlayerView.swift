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

    var body: some View {
        ZStack {
            Color(.systemGray6) // light background
                .ignoresSafeArea()

            VStack(spacing: 40) {
                if vm.currentIndex < vm.poses.count {
                    let pose = vm.poses[vm.currentIndex]

                    // Pose image
                    if let localImage = UIImage(named: pose.name) {
                        Image(uiImage: localImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 260, height: 260)
                    } else {
                        AsyncImage(url: URL(string: pose.imageURL)) { img in
                            img.resizable()
                                .scaledToFit()
                                .frame(width: 260, height: 260)
                        } placeholder: {
                            ProgressView()
                        }
                    }


                    // Pose name
                    Text(pose.name)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    // Countdown timer
                    Text(String(format: "0:%02d", vm.timeRemaining))
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.gray)

                    // Control buttons
                    HStack(spacing: 60) {
                        Button(action: {
                            if vm.currentIndex > 0 {
                                vm.currentIndex -= 1
                                vm.timeRemaining = 40
                            }
                        }) {
                            Image(systemName: "backward.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.orange)
                        }

                        Button(action: {
                            vm.advancePose()
                        }) {
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.orange)
                        }

                        Button(action: {
                            vm.advancePose()
                        }) {
                            Image(systemName: "forward.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.orange)
                        }
                    }
                }
            }
            .padding()
        }
        // Navigate to completed screen when workout ends
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
}
