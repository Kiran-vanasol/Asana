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
                ZStack {
                    // Pose Image
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

                Text(pose.name)
                    .font(.title)
                    .bold()

                Group {
                    Text("Benefits")
                        .font(.headline)
                    Text(pose.benefits)

                    Text("Caution")
                        .font(.headline)
                    Text(pose.caution)

                    Text("How to Prepare")
                        .font(.headline)
                    Text(pose.howToPrepare)
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
    }
}
