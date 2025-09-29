//
//  MusicViewModel.swift
//  Asana
//
//  Created by Kiran T C on 27/09/25.
//


import Foundation

@MainActor
class MusicViewModel: ObservableObject {
    @Published var poses: [MusicPose] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    private let apiURL = "https://cyeyivvm1m.execute-api.ap-south-1.amazonaws.com/default/getposes"

    func fetchPoses(for category: String) async {
        isLoading = true
        errorMessage = nil

        guard let url = URL(string: apiURL) else {
            errorMessage = "Invalid API URL"
            isLoading = false
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode([MusicPose].self, from: data)
            self.poses = decoded.filter { $0.category == category }
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
