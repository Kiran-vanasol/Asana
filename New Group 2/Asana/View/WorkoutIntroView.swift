//
//  WorkoutIntroView.swift
//  Asana
//
//  Created by Kiran T C on 12/09/25.
//

// WorkoutIntroView.swift
import SwiftUI

struct WorkoutIntroView: View {
    @StateObject private var vm: WorkoutViewModel
    @State private var goToPlayer = false

    // init so caller can pass a pre-configured VM
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
                // Optional: show a small "Preparing..." while we navigate
                Text("Preparing session…")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        // navigation uses parent NavigationStack (BackPainView has it)
        .navigationDestination(isPresented: $goToPlayer) {
            // pass the same VM (owned by this intro view) to the player
            WorkoutPlayerView(vm: vm)
        }
        .onAppear {
            print("DEBUG: WorkoutIntroView appeared")
            vm.startIntro()
        }
        .onChange(of: vm.isIntroActive) { active in
            print("DEBUG: isIntroActive changed -> \(active)")
            if !active {
                // start workout and then navigate — use async dispatch to let SwiftUI update view
                DispatchQueue.main.async {
                    print("DEBUG: starting workout then navigating to player")
                    vm.startWorkout()
                    goToPlayer = true
                }
            }
        }
    }
}
