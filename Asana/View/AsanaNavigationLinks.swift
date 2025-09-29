//
//  AsanaNavigationLinks.swift
//  Asana
//
//  Created by Kiran T C on 08/09/25.
//

import SwiftUI

struct AsanaNavigationLinks: View {
    let item: AsanaItem

    var body: some View {
        NavigationLink(destination: destinationView(for: item)) {
            CachedAsyncImage(url: URL(string: item.s3_url)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .scaledToFill()
            .frame(width: 240, height: 260)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 1, y: 2)
        }
    }

    @ViewBuilder
    private func destinationView(for item: AsanaItem) -> some View {
        switch item.name {
        case "YogaForPosture": PostureView()
        case "YogaForBackPain": BackPainView()
        case "YogaForNeckPain": NeckPainView()
        case "EarthMelody": EarthMelodiesView()
        case "InnerEchoes": InnerEchoesView()
        case "WavesOfBliss": WavesOfBlissView()
        default:
            Text(item.name)
        }
    }
}
