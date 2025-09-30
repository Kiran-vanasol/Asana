//
//  AllStreaksCalendarView.swift
//  Asana
//
//  Created by Kiran T C on 22/09/25.
//

import SwiftUI

struct AllStreaksCalendarView: View {
    @State private var allDates: Set<String> = []
    @State private var displayedMonth = Date()
    @State private var currentStreak: Int = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                MonthHeaderView(displayedMonth: $displayedMonth)
                CalendarGridView(highlightDates: allDates, month: displayedMonth)
                StreakCardView(streakCount: currentStreak)

                Spacer()
                
            }
            .onAppear {
                StreakService.shared.fetchAllStreaks { result in
                    switch result {
                    case .success(let dict):
                        var set: Set<String> = []
                        for (_, info) in dict {
                            set.formUnion(info.dates)
                        }
                        DispatchQueue.main.async { allDates = set }
                    case .failure(let err):
                        print("Failed to fetch all streaks:", err.localizedDescription)
                    }
                }
            }
            .toolbar {
                ToolbarItem() {
                    HStack(spacing: 8) {
                        Image(systemName: "calendar")
                            .imageScale(.large)
                            .foregroundColor(Color(hex: "#EB784E"))
                        Text("Check Streak")
                            .font(.system(size: 24, weight: .bold, design: .serif))
                            .foregroundColor(Color(hex: "#EB784E"))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }

        }
    }
}
