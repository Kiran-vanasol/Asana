//
//  AsanaApp.swift
//  Asana
//
//  Created by Kiran T C on 03/09/25.
//

import SwiftUI
import FirebaseCore

#if canImport(GoogleSignIn)
import GoogleSignIn
#endif

// iOS App Delegate
#if os(iOS)
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }

    // Handle Google Sign-In callback URL (iOS)
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        #if canImport(GoogleSignIn)
        return GIDSignIn.sharedInstance.handle(url)
        #else
        return false
        #endif
    }
}
#endif

// macOS App Delegate
#if os(macOS)
class MacAppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        FirebaseApp.configure()
    }
}
#endif

@main
struct AsanaApp: App {
    #if os(iOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    #elseif os(macOS)
    @NSApplicationDelegateAdaptor(MacAppDelegate.self) var macDelegate
    #endif

    @StateObject private var authService = AuthService.shared
    @StateObject private var coordinator = NavigationCoordinator.shared

    @State private var pendingRoute: AppRoute? = nil

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                if authService.user != nil {
                    HomeView()
                        .navigationDestination(for: AppRoute.self) { route in
                            switch route {
                            case .home: HomeView()
                            case .backPain: BackPainView()
                            case .neckPain: NeckPainView()
                            case .posture: PostureView()
                            case .earthMelody: EarthMelodiesView()
                            case .innerEchoes: InnerEchoesView()
                            case .wavesOfBliss: WavesOfBlissView()
                            }
                        }
                       
                        .onAppear {
                            if let route = pendingRoute {
                                print(" Processing pending route after login: \(route)")
                                coordinator.navigateTo(route)
                                pendingRoute = nil
                            }
                        }
                } else {
                    WelcomeView()
                }
            }
            .environmentObject(authService)
            .onOpenURL { url in
                if let route = routeForURL(url) {
                    if authService.user != nil {
                       
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            print("Navigating immediately to \(route)")
                            coordinator.navigateTo(route)
                        }
                    } else {
                       
                        print("Queued pending route: \(route)")
                        pendingRoute = route
                    }
                }
            }
        }
    }

    private func routeForURL(_ url: URL) -> AppRoute? {
        guard url.scheme == "asana", url.host == "open" else { return nil }
        let id = url.lastPathComponent.lowercased()
        print("👉 [DeepLink] Received URL: \(url.absoluteString), parsed id = \(id)")

        switch id {
        case "home": return .home
        case "backpain": return .backPain
        case "neckpain": return .neckPain
        case "posture": return .posture
        case "earthmelody": return .earthMelody
        case "innerechoes": return .innerEchoes
        case "wavesofbliss": return .wavesOfBliss
        default: return nil
        }
    }

}
