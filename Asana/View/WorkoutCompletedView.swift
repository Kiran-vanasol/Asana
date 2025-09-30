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
    @State private var rating: Int = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                
                Image("Streakasana")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                HStack {
                    Text("🔥")
                        .font(.system(size: 48))
                    
                    Text("\(streakVM.streakCount)")
                        .font(.system(size: 46, weight: .bold, design: .serif))
                        .foregroundColor(.primary)
                }
                
                Text("Day Streak!!")
                    .font(.title2)
                    .foregroundColor(Color(red: 235/255, green: 120/255, blue: 78/255))
                    .fontWeight(.semibold)
                Text("One Breath At A Time")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 235/255, green: 120/255, blue: 78/255))
                Text("You’re on fire! Keep the flame lit every day!")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 36)
                    .foregroundColor(.secondary)
                
                Text("Keep the vibes high and the stress low. Come back tomorrow for another dose of peace and positivity!")
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 20)
                    .foregroundColor(.secondary)
                
                
                
                
                WeekRowView(datesSet: streakVM.dates)
                
                HStack(spacing: 8) {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= rating ? "star.fill" : "star")
                            .foregroundColor(.orange)
                            .font(.title3)
                            .onTapGesture {
                                rating = index
                                print("User selected rating: \(rating)")
                            }
                    }
                }
                .padding(.top, 16)
                
                Spacer()
                
                Button("Submit Rating") {
                    //  rating submission logic here
                }
                .font(.subheadline)
                .foregroundColor(Color.orange)
                .padding(.top, 4)
                
                
                Button(action: { dismiss() }) {
                    Text("Skip")
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
                let isToday = calendar.isDateInToday(d)
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
