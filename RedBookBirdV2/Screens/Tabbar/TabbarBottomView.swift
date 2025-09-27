import SwiftUI

/// Модель элемента таббара
struct TabbarItem {
    let icon: String
}

struct TabbarBottomView: View {
    @Binding var selectedTab: AppTabScreen
    
    /// Элементы таббара
    private let tabbarItems: [TabbarItem] = [
        TabbarItem(icon: "catalog"),
        TabbarItem(icon: "personal"),
        TabbarItem(icon: "history"),
        TabbarItem(icon: "knowledge"),
        TabbarItem(icon: "settings")
    ]
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Spacer()
            
            ForEach(tabbarItems.indices, id: \.self) { index in
                VStack(spacing: 0) {
                    Image(tabbarItems[index].icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 63, height: 63, alignment: .center)
                    
                    Spacer()
                }
                .foregroundColor(selectedTab.selectedTabScreenIndex == index
                                 ? .customLightOrange : .customLightGray)
                .onTapGesture {
                    switch index {
                    case 1: selectedTab = .personal
                    case 2: selectedTab = .history
                    case 3: selectedTab = .knowledge
                    case 4: selectedTab = .settings
                    default: selectedTab = .catalog
                    }
                }
            }
            
            Spacer()
        }
        .frame(height: AppConfig.adaptiveTabbarHeight)
        .background(.white)
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 20))
    }
}

// MARK: - Preview

#Preview("LightEN") {
    TabbarMainView()
        .environmentObject(AppRouter.shared)
        .environmentObject(TabbarService.shared)
}
