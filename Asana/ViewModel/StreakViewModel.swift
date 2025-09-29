//
//  StreakViewModel.swift
//  Asana
//
//  Created by Kiran T C on 22/09/25.
//

import Foundation
import Combine

final class StreakViewModel: ObservableObject {
    @Published var streakCount: Int = 0
    @Published var lastCompleted: Date?
    @Published var dates: Set<String> = []

    private let workoutId: String

    init(workoutId: String) {
        self.workoutId = workoutId
        load()
    }

    func load() {
        StreakService.shared.fetchStreak(for: workoutId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let info):
                    self?.streakCount = info.streakCount
                    self?.lastCompleted = info.lastCompleted
                    self?.dates = Set(info.dates)
                case .failure(let error):
                    print("streak load error:", error.localizedDescription)
                }
            }
        }
    }

    func recordCompletion(_ completion: ((Result<Void, Error>) -> Void)? = nil) {
        StreakService.shared.recordCompletion(for: workoutId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let info):
                    self?.streakCount = info.streakCount
                    self?.lastCompleted = info.lastCompleted
                    self?.dates = Set(info.dates)
                    completion?(.success(()))
                case .failure(let error):
                    completion?(.failure(error))
                }
            }
        }
    }
}
