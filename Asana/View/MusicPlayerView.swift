//
//  MusicPlayerView.swift
//  Asana
//
//  Created by Kiran T C on 23/09/25.
//

import SwiftUI

struct MusicPlayerView: View {
    @ObservedObject var vm: MusicPlayerViewModel
    @State private var goToCompleted = false
    @StateObject private var streakVM: StreakViewModel
    
    init(vm: MusicPlayerViewModel) {
        self.vm = vm
        _streakVM = StateObject(wrappedValue: StreakViewModel(workoutId: vm.sessionId))
    }
    
    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                Spacer()
                
                // Track Image in Circle
                if vm.currentIndex < vm.poses.count {
                    let track = vm.poses[vm.currentIndex]
                    
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 6)
                            .frame(width: 300, height: 300)
                        if let localImage = UIImage(named: track.name) {
                            Image(uiImage: localImage)
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .padding(6)
                        } else {
                            AsyncImage(url: URL(string: track.imageURL)) { img in
                                img.resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .padding(24)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                    
                    // Track Name
                    Text(track.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top, 16)
                }
                
                // Controls
                HStack(spacing: 60) {
                    CircleButton(icon: "backward.fill") {
                        vm.previousTrack()
                    }
                    
                    Button(action: {
                        vm.isPlaying ? vm.pause() : vm.play()
                    }) {
                        Image(systemName: vm.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                            .frame(width: 70, height: 70)
                            .background(Circle().fill(Color(hex: "#EB784E") ?? .orange))
                    }
                    
                    CircleButton(icon: "forward.fill") {
                        vm.nextTrack()
                    }
                }
                .padding(.top, 24)
                
                Spacer()
            }
            .padding(.vertical, 20)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Meditation")
                    .font(.system(size: 24, weight: .bold, design: .serif))
                    .foregroundColor(Color(hex: "#EB784E"))
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // optional menu
                } label: {
                    Image(systemName: "line.horizontal.3")
                        .foregroundColor(Color(hex: "#171717"))
                }
            }
        }
        .onChange(of: vm.isFinished) { finished in
            if finished { goToCompleted = true }
        }
        .navigationDestination(isPresented: $goToCompleted) {
            WorkoutCompletedView(streakVM: streakVM)
        }
        .onAppear {
            if !vm.isPlaying {
                vm.play()
            }
        }

    }
}
