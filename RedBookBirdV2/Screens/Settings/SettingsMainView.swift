import SwiftUI

// MARK: - Settings Main View

/// Главный экран настроек
struct SettingsMainView: View {
    @EnvironmentObject private var settingsService: SettingsService
    @EnvironmentObject private var tabbarService: TabbarService
    
    @State private var urlString: String?
    
    @State private var isShowRemoveAlert = false
    
    var body: some View {
        ZStack(alignment: .center) {
            BackGroundView()
            
            VStack(alignment: .leading, spacing: 20) {
                // Title
                Text("Settings")
                    .font(.customFont(font: .regular, size: 32))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                // Settings rows
                VStack(spacing: 12) {
                    // Notifications
                    SettingsRowView(
                        title: "Notifications",
                        trailingContent: AnyView(
                            ToggleContent(
                                isOn: $settingsService.isNotificationsEnabled
                            ) { newValue in
                                Task { await settingsService.setNotifications(enabled: newValue) }
                            }
                        )
                    )
                    
                    SettingsRowView(
                        title: "Remove all the data",
                        action: {
                            isShowRemoveAlert.toggle()
                        },
                        trailingContent: AnyView(Image(systemName: "multiply").foregroundStyle(.red))
                    )
                    
                    // About the application
                    SettingsRowView(
                        title: "About the application",
                        action: {
                            tabbarService.isTabbarVisible = false
                            urlString = "https://sites.google.com/view/redbookbird/home"
                        },
                        trailingContent: AnyView(ChevronContent())
                    )
                    
                    SettingsRowView(
                        title: "Privacy Policy",
                        action: {
                            tabbarService.isTabbarVisible = false
                            urlString = "https://sites.google.com/view/redbookbird/privacy-policy"
                        },
                        trailingContent: AnyView(ChevronContent())
                    )
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            if let urlString,
               let url = URL(string: urlString) {
                WebView(url: url) {
                    self.urlString = nil
                    tabbarService.isTabbarVisible = true
                }
                .ignoresSafeArea(edges: [.bottom])
            }
        }
        .alert("Are you sure you want to delete all the data?", isPresented: $isShowRemoveAlert) {
            Button("Yes", role: .destructive) {
                ObservationService.shared.removeAll()
            }
        }
        .alert("The permission denied. Open Settings?", isPresented: $settingsService.isCancelled) {
            Button("Yes") {
                openSettings()
            }
            
            Button("Cancel") {}
        }
        .onAppear {
            tabbarService.isTabbarVisible = true
        }
    }
    
    private func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
}

// MARK: - Preview

#Preview("LightEN") {
    SettingsMainView()
        .environmentObject(AppRouter.shared)
        .environmentObject(SettingsService.shared)
        .environmentObject(TabbarService.shared)
}
