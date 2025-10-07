import SwiftUI

// MARK: - Custom Font Enum
/// Перечисление для управления кастомными шрифтами приложения
enum BalooBhaina: String {
    case regular = "BalooBhaina-Regular"
}

// MARK: - Font Extension
/// Расширение для Font с удобным методом создания кастомных шрифтов
extension Font {
    /// Создает кастомный шрифт с указанным размером
    /// - Parameters:
    ///   - font: Тип шрифта из enum BalooBhaina
    ///   - size: Размер шрифта
    /// - Returns: SwiftUI.Font с кастомным шрифтом
    static func customFont(font: BalooBhaina, size: CGFloat) -> SwiftUI.Font {
        .custom(font.rawValue, size: size)
    }
}

import SwiftUI
import SwiftUI
import CryptoKit
import WebKit
import AppTrackingTransparency
import UIKit
import FirebaseCore
import FirebaseRemoteConfig
import OneSignalFramework
import AdSupport

extension UIApplication {
    static var keyWindow: UIWindow {
        shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .last!
    }
    
    class func topMostController(controller: UIViewController? = keyWindow.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topMostController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController, let selected = tabController.selectedViewController {
            return topMostController(controller: selected)
        }
        if let presented = controller?.presentedViewController {
            return topMostController(controller: presented)
        }
        return controller
    }
}
