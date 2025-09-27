import SwiftUI

// MARK: - Settings Main View

/// Главный экран настроек
struct SettingsMainView: View {
    @EnvironmentObject private var settingsService: SettingsService
    @EnvironmentObject private var tabbarService: TabbarService
    
    @State private var urlString: String?
    
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
                
                //                    // Action buttons
                //                    HStack(spacing: 16) {
                //                        // Import button
                //                        Button(action: {
                //                            settingsService.importData()
                //                        }) {
                //                            Text("Import")
                //                                .font(.customFont(font: .regular, size: 22))
                //                                .foregroundStyle(.white)
                //                                .frame(maxWidth: .infinity)
                //                                .padding(.vertical, 16)
                //                                .background(Color.blue)
                //                                .clipShape(RoundedRectangle(cornerRadius: 22))
                //                        }
                //                        .buttonStyle(.plain)
                //
                //                        // Export button
                //                        Button(action: {
                //                            settingsService.exportData()
                //                        }) {
                //                            Text("Export")
                //                                .font(.customFont(font: .regular, size: 22))
                //                                .foregroundStyle(.white)
                //                                .frame(maxWidth: .infinity)
                //                                .padding(.vertical, 16)
                //                                .background(Color.green)
                //                                .clipShape(RoundedRectangle(cornerRadius: 22))
                //                        }
                //                        .buttonStyle(.plain)
                //                    }
                
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
