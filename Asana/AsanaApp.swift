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


    var body: some Scene {
        WindowGroup {
            NavigationStack {
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
                } else {
                    WelcomeView() // first-time or logged-out users
                }
            }
            .environmentObject(authService)
            .onOpenURL { url in
                            handleDeepLink(url)
                        }
        }
    }
    private func handleDeepLink(_ url: URL) {
           guard url.scheme == "asana", url.host == "open" else { return }
           let id = url.lastPathComponent

           switch id.lowercased() {
           case "backpain": coordinator.navigateTo(.backPain)
           case "neckpain": coordinator.navigateTo(.neckPain)
           case "posture": coordinator.navigateTo(.posture)
           case "earthmelody": coordinator.navigateTo(.earthMelody)
           case "innerechoes": coordinator.navigateTo(.innerEchoes)
           case "wavesofbliss": coordinator.navigateTo(.wavesOfBliss)
           default: break
           }
       }
}
