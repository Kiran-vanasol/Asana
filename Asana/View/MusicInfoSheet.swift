//
//  MusicInfoSheet.swift
//  Asana
//
//  Created by Kiran T C on 26/09/25.
//

//
//  PoseInfoSheet.swift
//  Asana
//
//  Created by Kiran T C on 25/09/25.
//

import SwiftUI

struct MusicInfoSheet: View {
    let pose: MusicPose
    let onDismiss: () -> Void   

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(pose.name)
                    .font(.system(size: 24, weight: .bold, design: .serif))
                    .foregroundColor(Color(red: 61/255, green: 122/255, blue: 85/255))
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
                    Text("Resonates With")
                        .font(.system(size: 20, weight: .bold, design: .serif))
                        .foregroundColor(Color(red: 61/255, green: 122/255, blue: 85/255))

                    Text(pose.resonatesWith!)
                        .font(.system(size: 16, weight: .regular, design: .serif))
                        .foregroundColor(.secondary)
                    
                    Text("Focus On This Sound When")
                        .font(.system(size: 20, weight: .bold, design: .serif))
                        .foregroundColor(Color(red: 61/255, green: 122/255, blue: 85/255))

                    Text(pose.focusOnThisInstrumentWhen!)
                        .font(.system(size: 16, weight: .regular, design: .serif))
                        .foregroundColor(.secondary)
                    
                    Text("Physical Body Assosiation")
                        .font(.system(size: 20, weight: .bold, design: .serif))
                        .foregroundColor(Color(red: 61/255, green: 122/255, blue: 85/255))

                    Text(pose.physicalBodyAssociation!)
                        .font(.system(size: 16, weight: .regular, design: .serif))
                        .foregroundColor(.secondary)
                    Text("Sound")
                        .font(.system(size: 20, weight: .bold, design: .serif))
                        .foregroundColor(Color(red: 61/255, green: 122/255, blue: 85/255))

                    Text(pose.sound!)
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
