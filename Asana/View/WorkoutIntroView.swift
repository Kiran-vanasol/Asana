//
//  WorkoutIntroView.swift
//  Asana
//
//  Created by Kiran T C on 12/09/25.
//

import SwiftUI

struct WorkoutIntroView: View {
    @StateObject private var vm: WorkoutViewModel
    @State private var goToPlayer = false

    // Caller injects pre-configured VM with poses + workoutType
    init(vm: WorkoutViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        VStack(spacing: 20) {
            if vm.isIntroActive {
                Text("Get Ready!")
                    .font(.largeTitle)
                    .bold()

                if let firstPose = vm.poses.first {
                    Text("Starting with \(firstPose.name)")
                        .font(.title2)
                }

                Text("\(vm.introCountdown)")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.orange)
            } else {
                Text("Preparing session…")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .navigationDestination(isPresented: $goToPlayer) {
            WorkoutPlayerView(vm: vm)
        }
        .onAppear {
            print("DEBUG: WorkoutIntroView appeared")
            vm.startIntro()
        }
        .onChange(of: vm.isIntroActive) { active in
            print("DEBUG: isIntroActive changed -> \(active)")
            if !active {
                DispatchQueue.main.async {
                    goToPlayer = true
                }
            }
        }
    }
}
