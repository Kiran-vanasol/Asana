//
//  StreakService.swift
//  Asana
//
//  Created by Kiran T C on 22/09/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct StreakInfo {
    let streakCount: Int
    let lastCompleted: Date?
    let dates: [String]
}

final class StreakService {
    static let shared = StreakService()
    private let db = Firestore.firestore()
    private init() {}

  
    func recordCompletion(for workoutId: String, completion: @escaping (Result<StreakInfo, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "StreakService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not signed in"])))
            return
        }

        let docRef = db.collection("users").document(uid).collection("streaks").document(workoutId)

        db.runTransaction({ transaction, errorPointer -> Any? in
            let snapshot: DocumentSnapshot
            do {
                snapshot = try transaction.getDocument(docRef)
            } catch {
                errorPointer?.pointee = error as NSError
                return nil
            }

            let now = Date()
            let todayIso = now.isoDateString
            let yesterdayIso = now.yesterdayStartOfDay.isoDateString

            var dates = snapshot.data()?["dates"] as? [String] ?? []
            let lastTS = snapshot.data()?["lastCompleted"] as? Timestamp
            let lastDate = lastTS?.dateValue()
            let lastIso = lastDate?.isoDateString

            if lastIso == todayIso {
                let current = snapshot.data()?["streakCount"] as? Int ?? 1
                return ["streakCount": current, "lastCompleted": lastTS as Any, "dates": dates]
            }

            var newStreak = 1
            if lastIso == yesterdayIso {
                newStreak = (snapshot.data()?["streakCount"] as? Int ?? 0) + 1
            } else {
                newStreak = 1
            }

            if !dates.contains(todayIso) {
                dates.append(todayIso)
            }

            let update: [String: Any] = [
                "streakCount": newStreak,
                "lastCompleted": Timestamp(date: now),
                "dates": dates
            ]

            transaction.setData(update, forDocument: docRef, merge: true)
            return update

        }, completion: { result, error in
            if let error = error { completion(.failure(error)); return }
            if let m = result as? [String:Any] {
                let streak = m["streakCount"] as? Int ?? 1
                let last = (m["lastCompleted"] as? Timestamp)?.dateValue()
                let dates = m["dates"] as? [String] ?? []
                completion(.success(StreakInfo(streakCount: streak, lastCompleted: last, dates: dates)))
            } else {
                completion(.failure(NSError(domain: "StreakService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Unexpected transaction result"])))
            }
        })
    }
    func fetchStreak(for workoutId: String, completion: @escaping (Result<StreakInfo, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "StreakService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not signed in"])))
            return
        }

        let docRef = db.collection("users").document(uid).collection("streaks").document(workoutId)
        docRef.getDocument { snapshot, error in
            if let error = error { completion(.failure(error)); return }
            let data = snapshot?.data() ?? [:]
            let streak = data["streakCount"] as? Int ?? 0
            let last = (data["lastCompleted"] as? Timestamp)?.dateValue()
            let dates = data["dates"] as? [String] ?? []
            completion(.success(StreakInfo(streakCount: streak, lastCompleted: last, dates: dates)))
        }
    }

    // Fetch all streaks (useful for profile calendar)
    func fetchAllStreaks(completion: @escaping (Result<[String:StreakInfo], Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "StreakService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not signed in"])))
            return
        }

        let col = db.collection("users").document(uid).collection("streaks")
        col.getDocuments { snap, error in
            if let error = error { completion(.failure(error)); return }
            var dict: [String:StreakInfo] = [:]
            for doc in snap?.documents ?? [] {
                let id = doc.documentID
                let data = doc.data()
                let s = data["streakCount"] as? Int ?? 0
                let last = (data["lastCompleted"] as? Timestamp)?.dateValue()
                let dates = data["dates"] as? [String] ?? []
                dict[id] = StreakInfo(streakCount: s, lastCompleted: last, dates: dates)
            }
            completion(.success(dict))
        }
    }
}
