import Foundation

/// Сервис управления Tabbar.
final class TabbarService: ObservableObject {
    
    static let shared = TabbarService()
    private init() {}
    
    /// Флаг, указывающий, отображается ли Tabbar.
    @Published var isTabbarVisible: Bool = true
}
