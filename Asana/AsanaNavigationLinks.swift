//
//  AsanaNavigationLinks.swift
//  Asana
//
//  Created by Kiran T C on 08/09/25.
//

//
//  YogaNavigationLinks.swift
//  Asana
//
//  Created by Kiran T C on 08/09/25.
//

import SwiftUI

struct AsanaNavigationLinks: View {
    let img: String   // Takes the image name
    
    var body: some View {
        switch img {
        case "YogaForPosture":
            NavigationLink(destination: PostureView(
                title: "Yoga For Posture",
                poses: PoseCollections.yogaForPosture   
            ))  {
                Image(img)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 240, height: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 1, y: 2)
            }
            
        case "YogaForBackPain":
            NavigationLink(destination: Text("Back Pain View (Coming Soon)"))  {
                Image(img)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 240, height: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 1, y: 2)
            }
            
        case "YogaForNeckPain":
            NavigationLink(destination: Text("Neck Pain View (Coming Soon)"))  {
                Image(img)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 240, height: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 1, y: 2)
            }
            
        default:
            Image(img)
                .resizable()
                .scaledToFill()
                .frame(width: 240, height: 260)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 1, y: 2)        }
    }
}
