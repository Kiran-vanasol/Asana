//
//  AllStreaksCalendarView.swift
//  Asana
//
//  Created by Kiran T C on 22/09/25.
//

import SwiftUI

struct AllStreaksCalendarView: View {
    @State private var allDates: Set<String> = []

    var body: some View {
        NavigationStack {
            VStack {
                Text("Streak Calendar").font(.title2).padding(.top)
                CalendarGridView(highlightDates: allDates)
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
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil) }
                }
            }
        }
    }
}
