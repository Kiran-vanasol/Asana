//
//  WorkoutCompletedView.swift
//  Asana
//
//  Created by Kiran T C on 12/09/25.
//

import SwiftUI

struct WorkoutCompletedView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text(" Workout Completed!")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.green)

            Text("Great job finishing your yoga session.")
                .font(.title2)
                .multilineTextAlignment(.center)

            Button("Done") {
                // TODO: Handle dismissal too   maybe to  later we think
                
            }
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .padding()
    }
}
