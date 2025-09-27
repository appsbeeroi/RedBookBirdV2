import SwiftUI

@main
struct RedBookBirdV2App: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(AppRouter.shared)
                .environmentObject(TabbarService.shared)
                .environmentObject(BirdMarkService.shared)
                .environmentObject(ObservationService.shared)
                .environmentObject(SettingsService.shared)
                .dynamicTypeSize(.large)
                .preferredColorScheme(.light)
                .background(.white)
        }
    }
}
