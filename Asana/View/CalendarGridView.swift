//
//  CalendarGridView.swift
//  Asana
//
//  Created by Kiran T C on 22/09/25.
//

import SwiftUI

struct CalendarGridView: View {
    let highlightDates: Set<String>
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    let month: Date

    private func monthDates(for base: Date) -> [Date] {
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: base),
              let start = calendar.date(from: calendar.dateComponents([.year, .month], from: base))
        else { return [] }

        let blanks = calendar.component(.weekday, from: start) - 1
        var result = Array(repeating: Date.distantPast, count: blanks)
        result += range.compactMap { calendar.date(byAdding: .day, value: $0 - 1, to: start) }
        return result
    }


    var body: some View {
        VStack(spacing: 16) {
            HStack {
                        ForEach(["S","M","T","W","T","F","S"], id: \.self) { w in
                            Text(w)
                                .frame(maxWidth: .infinity)
                                .font(.caption)          // optional: smaller weekday font
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.bottom, 4)
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(monthDates(for: month), id: \.self) { d in
                    if d == Date.distantPast {
                        Color.clear.frame(height: 36)
                    } else {
                        let iso = d.isoDateString
                        let isHighlighted = highlightDates.contains(iso)
                        let isToday = Calendar.current.isDateInToday(d)

                        ZStack {
                            if isHighlighted {
                                   RoundedRectangle(cornerRadius: 20)
                                       .fill(Color.orange.opacity(0.25))
                                       .padding(4)
                               }
                            Text("\(Calendar.current.component(.day, from: d))")
                                .foregroundColor(isHighlighted ? .orange : .primary)
                                .fontWeight(isHighlighted ? .bold : .regular)

                            // blue dot for today
                            if isToday {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 6, height: 6)
                                    .offset(y: 14)
                            }
                        }
                        .frame(maxWidth: .infinity, minHeight: 36)
                    }
                }
            }

        }
    }
}
