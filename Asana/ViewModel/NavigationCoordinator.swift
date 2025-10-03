//
//  NavigationCoordinator.swift
//  Asana
//
//  Created by Kiran T C on 02/10/25.
//

import SwiftUI

enum AppRoute: Hashable {
    case home
    case backPain
    case neckPain
    case posture
    case earthMelody
    case innerEchoes
    case wavesOfBliss
}

class NavigationCoordinator: ObservableObject {
    static let shared = NavigationCoordinator()
    
    @Published var path = NavigationPath()
    
    
    private init() {}
    
    func navigateTo(_ route: AppRoute) {
          print(" NavigationCoordinator: navigating to \(route)")

          //  Safe reset: build a fresh path with the new destination
          var newPath = NavigationPath()
          newPath.append(route)
          path = newPath
      }
}
