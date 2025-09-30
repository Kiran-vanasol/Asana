//
//  StreakcardView.swift
//  Asana
//
//  Created by Kiran T C on 29/09/25.
//

import Foundation
import SwiftUI

struct StreakCardView: View {
    let streakCount: Int

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "flame.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(Color(hex: "#EB784E"))

            VStack(alignment: .leading, spacing: 4) {
                Text("Current Streak")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Text("\(streakCount) days")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color(hex: "#EB784E"))
                   
            }
            .frame(maxWidth: .infinity, alignment: .center)

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
}

