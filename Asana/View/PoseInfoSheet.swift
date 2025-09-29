//
//  PoseInfoSheet.swift
//  Asana
//
//  Created by Kiran T C on 25/09/25.
//

import SwiftUI

struct PoseInfoSheet: View {
    let pose: APIPose
    let onDismiss: () -> Void   // so we can resume timer from outside

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(pose.name)
                    .font(.system(size: 24, weight: .bold, design: .serif))
                    .foregroundColor(Color(hex: "#EB784E"))
                    .frame(maxWidth: .infinity, alignment: .center)
                ZStack {
                    // Pose Image
                    Text(pose.name)
                        .font(.title)
                        .bold()
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
                .frame(width: 250, height: 250)
                .frame(maxWidth: .infinity, alignment: .center)

                

                Group {
                    
                    Text("How to Prepare")
                        .font(.system(size: 20, weight: .bold, design: .serif))
                        .foregroundColor(Color(hex: "#EB784E"))
                    Text(pose.howToPrepare)
                        .font(.system(size: 16, weight: .regular, design: .serif))
                        .foregroundColor(.secondary)
                    

                    Text("Caution")
                        .font(.system(size: 20, weight: .bold, design: .serif))
                        .foregroundColor(Color(hex: "#EB784E"))
                    Text(pose.caution)
                        .font(.system(size: 16, weight: .regular, design: .serif))
                        .foregroundColor(.secondary)
                    
                    Text("Benefits")
                        .font(.system(size: 20, weight: .bold, design: .serif))
                        .foregroundColor(Color(hex: "#EB784E"))
                    Text(pose.benefits)
                        .font(.system(size: 16, weight: .regular, design: .serif))
                        .foregroundColor(.secondary)

                }
                .padding(.bottom, 8)
            }
            .padding()
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Close") {
                    onDismiss()
                }
            }
        }
        .onAppear {
            print("Pose Info Sheet Appeared")
        }
    }
}
