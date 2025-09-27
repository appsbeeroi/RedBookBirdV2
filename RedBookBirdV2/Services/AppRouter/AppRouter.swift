import Foundation
import SwiftUI

// MARK: - App Router

/// Глобальный роутер приложения для управления навигацией
@MainActor
final class AppRouter: ObservableObject {
    
    static let shared = AppRouter()
    private init() {}
    
    /// Текущий основной экран приложения
    @Published var currentMainScreen: AppMainScreen = .splash
    /// Стек экранов вкладки "catalog"
    @Published var catalogRoute: [CatalogScreen] = []
    /// Стек экранов вкладки "personal"
    @Published var personalRoute: [PersonalScreen] = []
    /// Стек экранов вкладки "history"
    @Published var historyRoute: [HistoryScreen] = []
    /// Стек экранов вкладки "knowledge"
    @Published var knowledgeRoute: [KnowledgeScreen] = []
    /// Стек экранов вкладки "settings"
    @Published var settingsRoute: [SettingsScreen] = []
}

enum AppMainScreen {
    case splash
    case tabbar
}

enum CatalogScreen: Hashable {
    case main
    case detail
}

enum PersonalScreen {
    case main
    case addObservation
    case observationDetail
}

enum HistoryScreen: Hashable {
    case main
    case observationDetail
}

enum KnowledgeScreen: Hashable {
    case main
    case articleDetail
}

enum SettingsScreen {
    case main
}

// MARK: - Вкладки приложения с индексами

/// Вкладки таббара с индексами.
/// Определяет порядок и индексы вкладок в TabBar.
enum AppTabScreen {
    case catalog
    case personal
    case history
    case knowledge
    case settings
    
    /// Индекс для выбранной вкладки.
    var selectedTabScreenIndex: Int {
        switch self {
        case .catalog:
            return 0
        case .personal:
            return 1
        case .history:
            return 2
        case .knowledge:
            return 3
        case .settings:
            return 4
        }
    }
}
