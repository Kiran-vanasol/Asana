//
//  ReminderViewModel.swift
//  Asana
//
//  Created by Kiran T C on 06/10/25.
//

import Foundation
import UserNotifications

@MainActor
class ReminderViewModel: ObservableObject {
    @Published var reminderTime = Date()
    @Published var titleText = ""
    @Published var selectedDays: Set<String> = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"] // default: all days
    @Published var showConfirmation = false
    
    private let daysMap: [String: (label: String, index: Int)] = [
        "Sun": ("S", 1),
        "Mon": ("M", 2),
        "Tue": ("T", 3),
        "Wed": ("W", 4),
        "Thu": ("T", 5),
        "Fri": ("F", 6),
        "Sat": ("S", 7)
    ]
    
    // MARK: - Request Permission
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Permission granted: \(granted)")
            }
        }
    }
    
    // MARK: - Schedule Notifications for Selected Days
    func saveReminder() {
        let content = UNMutableNotificationContent()
        content.title = titleText.isEmpty ? "Reminder" : titleText
        content.body = "It's time for your routine!"
        content.sound = .default
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: reminderTime)
        let minute = calendar.component(.minute, from: reminderTime)
        
        for (dayName, (_, weekdayIndex)) in daysMap {
            if selectedDays.contains(dayName) {
                var components = DateComponents()
                components.weekday = weekdayIndex
                components.hour = hour
                components.minute = minute
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                
                let request = UNNotificationRequest(
                    identifier: UUID().uuidString,
                    content: content,
                    trigger: trigger
                )
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error.localizedDescription)")
                    } else {
                        print("Scheduled for \(dayName) (\(weekdayIndex)) at \(hour):\(minute)")
                    }
                }
            }
        }
        
        DispatchQueue.main.async {
            self.showConfirmation = true
        }
    }
}
