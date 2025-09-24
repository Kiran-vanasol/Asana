//
//  HomeViewModel.swift
//  Asana
//
//  Created by Kiran T C on 24/09/25.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var asanas: [AsanaItem] = []
    @Published var meditate: [AsanaItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchHomeData() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        guard let url = URL(string: "https://2dkwpah0th.execute-api.ap-south-1.amazonaws.com/default/HomeView") else {
            errorMessage = "Invalid URL"
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(HomeResponse.self, from: data)
            self.asanas = decoded.asanas
            self.meditate = decoded.meditate
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
