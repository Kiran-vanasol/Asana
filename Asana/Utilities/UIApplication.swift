//
//  UIApplication.swift
//  Asana
//
//  Created by Kiran T C on 04/09/25.
//

#if os(iOS)
import UIKit

extension UIApplication {
    static func topViewController(base: UIViewController? = (UIApplication.shared.connectedScenes
                                                            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                                                            .first { $0.isKeyWindow }?.rootViewController)) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return topViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
#endif

