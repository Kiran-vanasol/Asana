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

    private var monthDates: [Date] {
        let calendar = Calendar.current
        let today = Date()
        guard let range = calendar.range(of: .day, in: .month, for: today),
              let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: today))
        else { return [] }

        let startWeekday = calendar.component(.weekday, from: monthStart) // 1=Sun
        let blanks = (startWeekday - 1) // blank slots before first day (Sunday-first)
        var dates: [Date] = []
        for _ in 0..<blanks { dates.append(Date.distantPast) }
        for d in range {
            if let date = calendar.date(byAdding: .day, value: d - 1, to: monthStart) {
                dates.append(date)
            }
        }
        return dates
    }

    var body: some View {
        VStack {
            HStack {
                ForEach(["S","M","T","W","T","F","S"], id: \.self) { w in
                    Text(w).frame(maxWidth: .infinity)
                }
            }
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(monthDates, id: \.self) { d in
                    if d == Date.distantPast {
                        Color.clear.frame(height: 36)
                    } else {
                        let iso = d.isoDateString
                        let isHighlighted = highlightDates.contains(iso)
                        Text(isHighlighted ? "●" : "\(Calendar.current.component(.day, from: d))")
                            .frame(maxWidth: .infinity, minHeight: 36)
                            .foregroundColor(isHighlighted ? .white : .primary)
                            .background(isHighlighted ? Color(red: 235/255, green: 120/255, blue: 78/255) : Color.clear)
                            .clipShape(Circle())
                    }
                }
            }.padding()
        }
    }
}
