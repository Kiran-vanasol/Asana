//
//  WorkoutCompletedView.swift
//  Asana
//
//  Created by Kiran T C on 12/09/25.
//

import SwiftUI

struct WorkoutCompletedView: View {
    @ObservedObject var streakVM: StreakViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 18) {
            Spacer().frame(height: 20)

            Text("🔥")
                .font(.system(size: 64))

            Text("\(streakVM.streakCount)")
                .font(.system(size: 46, weight: .bold, design: .rounded))
                .foregroundColor(.primary)

            Text("Day Streak!!")
                .font(.title2)
                .foregroundColor(Color(red: 235/255, green: 120/255, blue: 78/255))
                .fontWeight(.semibold)

            Text("You’re on fire! Keep the flame lit every day!")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 36)
                .foregroundColor(.secondary)

            WeekRowView(datesSet: streakVM.dates)

            Spacer()

            Button(action: { dismiss() }) {
                Text("Done")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .font(.headline)
            }
            .background(Color(red: 235/255, green: 120/255, blue: 78/255))
            .foregroundColor(.white)
            .cornerRadius(20)
            .padding(.horizontal, 36)
            .padding(.bottom, 24)
        }
        .background(Color(red: 234/255, green: 242/255, blue: 242/255))
        .ignoresSafeArea(edges: .bottom)
    }
}

// WeekRowView: shows current week's short letters and highlights done days
struct WeekRowView: View {
    let calendar = Calendar.current
    let datesSet: Set<String>

    private func currentWeekDates() -> [Date] {
        let today = Date()
        let weekday = calendar.component(.weekday, from: today) // 1 = Sun
        // find Monday start (adjust if you prefer Sunday)
        let daysFromMonday = (weekday + 6) % 7
        let monday = calendar.date(byAdding: .day, value: -daysFromMonday, to: today.startOfDay)!
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: monday) }
    }

    var body: some View {
        HStack(spacing: 12) {
            ForEach(currentWeekDates(), id: \.self) { d in
                let iso = d.isoDateString
                let isDone = datesSet.contains(iso)
                let short = String(calendar.shortWeekdaySymbols[calendar.component(.weekday, from: d) - 1].prefix(1))
                ZStack {
                    Circle()
                        .fill(isDone ? Color(red: 235/255, green: 120/255, blue: 78/255) : Color.white)
                        .frame(width: 36, height: 36)
                        .shadow(radius: isDone ? 2 : 0)

                    Text(short)
                        .font(.caption)
                        .foregroundColor(isDone ? .white : .gray)
                }
            }
        }
        .padding(.top, 8)
    }
}
