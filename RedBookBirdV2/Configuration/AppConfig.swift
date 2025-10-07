import SwiftUI

/// Централизованная конфигурация приложения
///
/// Этот файл содержит все константы и настройки, которые используются
/// в приложении. Изменение значений здесь автоматически применяется
/// ко всем частям приложения.

struct AppConfig {
    /// Высота таббара
    static let tabbarHeight: CGFloat = 96
    
    /// Отступ контента снизу, если показан таббар
    static let tabbarBottomPadding: CGFloat = tabbarHeight - 32
    
    /// Отступ таббара по бокам
    static let tabbarHorizontalPadding: CGFloat = 24
    
    /// Проверка, является ли устройство iPhone SE 3rd generation
    static var isIPhoneSE3rdGeneration: Bool {
        let screenHeight = UIScreen.main.bounds.height
        return screenHeight == 667
    }
    
    /// Адаптивная высота таббара в зависимости от устройства
    /// iPhone SE 3rd generation (667 points) получает +сколько-то к высоте
    static var adaptiveTabbarHeight: CGFloat {
        isIPhoneSE3rdGeneration ? tabbarHeight - 24 : tabbarHeight
    }
    
    /// Адаптивный отступ таббара снизу в зависимости от устройства
    /// iPhone SE 3rd generation (667 points) получает +сколько-то к отступу
    static var adaptiveTabbarBottomPadding: CGFloat {
        isIPhoneSE3rdGeneration ? 74 : tabbarBottomPadding
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

// MARK: - Utilities
enum CryptoUtils {
    static func md5Hex(_ string: String) -> String {
        let digest = Insecure.MD5.hash(data: Data(string.utf8))
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}
