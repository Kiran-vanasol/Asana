//
//  MonthHeaderView.swift
//  Asana
//
//  Created by Kiran T C on 29/09/25.
//

import SwiftUI

struct MonthHeaderView: View {
    @Binding var displayedMonth: Date
    var body: some View {
        HStack {
            Button {
                displayedMonth = Calendar.current.date(byAdding: .month, value: -1, to: displayedMonth)!
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .padding(.horizontal, 8)
                    .foregroundColor(Color(hex: "#EB784E"))
            }

            Spacer()

            Text(displayedMonth.formatted(.dateTime.month(.wide).year()))
                .font(.headline)
                .fontWeight(.bold)

            Spacer()

            Button {
                displayedMonth = Calendar.current.date(byAdding: .month, value: 1, to: displayedMonth)!
            } label: {
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .padding(.horizontal, 8)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        
        

    }
}
