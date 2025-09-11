//
//  PostureView.swift
//  Asana
//
//  Created by Kiran T C on 08/09/25.
//

import SwiftUI

// MARK: - Posture View
struct PostureView: View {
    var title: String
    var poses: [Pose]
    
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
                
                Text("Posture Reset")
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
            
            // List of Poses
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(poses) { pose in
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: "#C5C884")!)
                                    .frame(width: 60, height: 60)
                                
                                Image(pose.imageName)
                                    .resizable()
                                    .scaledToFit()
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
    }
}

// MARK: - Preview
struct PostureView_Previews: PreviewProvider {
    static var previews: some View {
        PostureView(
            title: "Posture Reset",
            poses: [
                Pose(name: "Mountain Pose", imageName: "mountain"),
                Pose(name: "Warrior Pose", imageName: "warrior"),
                Pose(name: "Forward Fold", imageName: "forwardFold"),
                Pose(name: "Dolphin Pose", imageName: "dolphin"),
                Pose(name: "Cow Pose", imageName: "cow"),
                Pose(name: "Cat Pose", imageName: "cat"),
                Pose(name: "Child’s Pose", imageName: "child"),
                Pose(name: "Pigeon Pose", imageName: "pigeon")
            ]
        )
    }
}
