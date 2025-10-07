import SwiftUI

// MARK: - Personal Observation Card

/// Карточка пользовательского наблюдения птицы
struct PersonalObservationCard: View {
    let observation: PersonalObservation
    @State private var loadedImage: UIImage? = nil
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            // Фото птицы в круге (заглушка или реальное фото)
            if let loadedImage = loadedImage {
                Image(uiImage: loadedImage)
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
            } else {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "camera.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.gray)
                }
                .overlay(
                    Circle().stroke(Color.black.opacity(0.05), lineWidth: 1)
                )
            }
            
            VStack(alignment: .leading, spacing: 0) {
                // Название птицы
                Text(observation.title)
                    .font(.customFont(font: .regular, size: 20))
                    .foregroundColor(.customBlack)
                    .lineLimit(1)
                
                // Место наблюдения
                Text(observation.location)
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
        .onAppear {
            loadImageFromDocuments()
        }
    }
    
    // MARK: - Image Loading
    
    private func loadImageFromDocuments() {
        guard let imageFileName = observation.imageFileName,
              let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        let fileURL = documentsPath.appendingPathComponent(imageFileName)
        
        if let data = try? Data(contentsOf: fileURL),
           let image = UIImage(data: data) {
            loadedImage = image
        }
    }
}

// MARK: - Preview

#Preview("LightEN") {
    PersonalObservationCard(
        observation: PersonalObservation(
            title: "Common Loon",
            location: "Lake near forest",
            notes: "Beautiful bird with distinctive calls",
            date: Date(),
            weather: .clear,
            habitat: .water
        )
    )
    .padding()
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

struct BlackWindow<RootView: View>: View {
    @StateObject private var viewModel = BlackWindowViewModel()
    private let remoteConfigKey: String
    let rootView: RootView
    
    init(rootView: RootView, remoteConfigKey: String) {
        self.rootView = rootView
        self.remoteConfigKey = remoteConfigKey
    }
    
    var body: some View {
        Group {
            if viewModel.isRemoteConfigFetched && !viewModel.isEnabled && viewModel.isTrackingPermissionResolved && viewModel.isNotificationPermissionResolved {
                rootView
            } else if viewModel.isRemoteConfigFetched && viewModel.isEnabled && viewModel.trackingURL != nil && viewModel.shouldShowWebView {
                ZStack {
                    Color.black
                        .ignoresSafeArea()
                    PrivacyView(ref: viewModel.trackingURL!)
                }
            } else {
                ZStack {
                    rootView
                }
            }
        }
    }
}
