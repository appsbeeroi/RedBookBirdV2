import SwiftUI

struct TabbarMainView: View {
    
    @EnvironmentObject private var tabbarService: TabbarService
    @State private var selectedTab: AppTabScreen = .catalog
    
    var body: some View {
        ZStack(alignment: .center) {
            Group {
                switch selectedTab {
                case .catalog:
                    CatalogMainView()
                case .personal:
                    PersonalMainView()
                case .history:
                    HistoryMainView()
                case .knowledge:
                    KnowledgeMainView()
                case .settings:
                    SettingsMainView()
                }
            }
            
            // Таббар поверх контента
            if tabbarService.isTabbarVisible {
                VStack(alignment: .center, spacing: 0) {
                    Spacer()
                    TabbarBottomView(selectedTab: $selectedTab)
                }
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

// MARK: - Preview

#Preview("LightEN") {
    TabbarMainView()
        .environmentObject(AppRouter.shared)
        .environmentObject(TabbarService.shared)
}
