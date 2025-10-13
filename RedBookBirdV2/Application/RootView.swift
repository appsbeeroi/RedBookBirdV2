import SwiftUI

struct RootView: View {
    
    @EnvironmentObject private var appRouter: AppRouter
    
    var body: some View {
        Group {
            switch appRouter.currentMainScreen {
            case .splash:
                SplashMainView()
            case .tabbar:
                TabbarMainView()
            }
        }
        .onAppear {
            Task {
                await SettingsService.shared.requestAuthorizationIfNeeded()
            }
        }
    }
}

// MARK: - Preview

#Preview("LightEN") {
    RootView()
        .environmentObject(AppRouter.shared)
}
