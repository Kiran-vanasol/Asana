//
//  ReminderView.swift
//  Asana
//
//  Created by Kiran T C on 06/10/25.
//

import SwiftUI

struct ReminderView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = ReminderViewModel()

    private let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    private let dayLabels: [String: String] = [
        "Sun": "S", "Mon": "M", "Tue": "T", "Wed": "W",
        "Thu": "T", "Fri": "F", "Sat": "S"
    ]

    var timeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("TIME")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)

            DatePicker("", selection: $vm.reminderTime, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 0.5))
        }
        .padding(.horizontal)
    }

    var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("TITLE")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)

            TextField("Eg. Wake Up Stretch", text: $vm.titleText)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 0.5))
        }
        .padding(.horizontal)
    }

    var repeatSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("REPEAT")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)
                .padding(.horizontal)

            HStack(spacing: 12) {
                ForEach(days, id: \.self) { day in
                    let label = dayLabels[day] ?? String(day.prefix(1))
                    Text(label)
                        .font(.system(size: 16, weight: .medium))
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(vm.selectedDays.contains(day) ? Color(hex: "#F17228")! : Color.white)
                        )
                        .overlay(Circle().stroke(Color.black.opacity(0.2), lineWidth: 0.5))
                        .foregroundColor(vm.selectedDays.contains(day) ? .white : .black)
                        .onTapGesture {
                            if vm.selectedDays.contains(day) {
                                vm.selectedDays.remove(day)
                            } else {
                                vm.selectedDays.insert(day)
                            }
                        }
                }
            }
            .padding(.horizontal)

            Text(vm.selectedDays.count == 7 ? "Every day" : "\(vm.selectedDays.count) day(s) selected")
                .font(.system(size: 14))
                .foregroundColor(.black)
                .padding(.horizontal)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                timeSection
                titleSection
                repeatSection
                Spacer()
            }
            .background(Color(hex: "#EAF2F2").ignoresSafeArea())
            .onAppear { vm.requestNotificationPermission() }
            .alert("Reminder Saved!", isPresented: $vm.showConfirmation) {
                Button("OK") { dismiss() }
            }
            .navigationTitle("Set Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.black)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { vm.saveReminder() }
                        .foregroundColor(.black)
                }
            }
        }
    }
}

#Preview {
    ReminderView()
}
