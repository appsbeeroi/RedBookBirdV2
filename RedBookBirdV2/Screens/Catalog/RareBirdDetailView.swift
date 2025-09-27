import SwiftUI

struct RareBirdDetailView: View {
    @EnvironmentObject private var appRouter: AppRouter
    @EnvironmentObject private var tabbarService: TabbarService
    @EnvironmentObject private var markService: BirdMarkService
    
    let birdId: UUID
    
    private var bird: RareBird? {
        RareBird.seed.first { $0.id == birdId }
    }
    
    // MARK: - Local UI State
    @State private var isMarkOverlayVisible: Bool = false
    @State private var pendingSelection: BirdMarkStatus = .none
    
    var body: some View {
        ZStack(alignment: .center) {
            BackGroundView()
            
            if let bird {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .center, spacing: 0) {
                        // Картинка на всю ширину с закруглением
                        Image(bird.imageFileName)
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                        
                        VStack(alignment: .leading, spacing: -16) {
                            // Заголовок
                            Text(bird.commonName)
                                .font(.customFont(font: .regular, size: 36))
                                .foregroundStyle(.customBlack)
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                                .lineSpacing(0)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // Статусы: уязвимость + (при наличии) отметка пользователя
                            HStack(spacing: 8) {
                                Text("Vulnerable")
                                    .font(.customFont(font: .regular, size: 16))
                                    .foregroundStyle(.customBlack)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Capsule().fill(Color.white))
                                
                                // Пилюля состояния отметки
                                let current = markService.status(forKey: bird.imageFileName)
                                if current != .none {
                                    HStack(spacing: 6) {
                                        Image(current == .met ? "selected" : "unselected")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 22, height: 22)
                                        Text(current == .met ? "Met" : "Want to find")
                                            .font(.customFont(font: .regular, size: 16))
                                            .foregroundStyle(.customBlack)
                                    }
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Capsule().fill(Color.white))
                                    .onTapGesture { showMarkOverlay(with: current) }
                                }
                            }
                            
                            // Описание
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Description")
                                    .font(.customFont(font: .regular, size: 16))
                                    .foregroundStyle(.customBlack.opacity(0.5))
                                Text(bird.summary)
                                    .font(.customFont(font: .regular, size: 20))
                                    .foregroundStyle(.customBlack)
                                    .lineSpacing(0)
                            }
                            .padding(.top, 16)
                            
                            // Ареал
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Range")
                                    .font(.customFont(font: .regular, size: 16))
                                    .foregroundStyle(.customBlack.opacity(0.5))
                                Text(bird.habitat)
                                    .font(.customFont(font: .regular, size: 20))
                                    .foregroundStyle(.customBlack)
                                    .lineSpacing(0)
                            }
                            .padding(.top, 16)
                        }
                        
                        Button {
                            showMarkOverlay(with: .none)
                        } label: {
                            Text("Mark as")
                                .font(.customFont(font: .regular, size: 25))
                                .foregroundStyle(.customBlack)
                                .frame(maxWidth: .infinity, minHeight: 64)
                                .background(isMarkButtonEnabled ? Color.customLightOrange : Color.customLightGray.opacity(0.6))
                                .clipShape(Capsule())
                        }
                        .disabled(!isMarkButtonEnabled)
                    }
                    .padding(.top, 20)
                }
                .padding(.horizontal)
            } else {
                Text("Bird not found")
                    .font(.customFont(font: .regular, size: 20))
                    .foregroundStyle(.customBlack)
            }
        }
        .onAppear {
            tabbarService.isTabbarVisible = false
        }
        // MARK: - Overlay Mark-As Alert
        .overlay(
            Group {
                if isMarkOverlayVisible, let bird {
                    ZStack(alignment: .center) {
                        Color.black.opacity(0.35)
                            .ignoresSafeArea()
                            .onTapGesture { isMarkOverlayVisible = false }
                        
                        VStack(alignment: .center, spacing: 4) {
                            HStack {
                                Spacer()
                                Button {
                                    isMarkOverlayVisible = false
                                } label: {
                                    Image(systemName: "xmark")
                                        .foregroundStyle(.customBlack)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.top, 6)
                            
                            Text("Mark as")
                                .font(.customFont(font: .regular, size: 22))
                                .foregroundStyle(.customBlack)
                            
                            HStack(spacing: 12) {
                                markOption(status: .met, title: "Met")
                                markOption(status: .wantToFind, title: "Want to find")
                            }
                            .padding(.horizontal)
                            
                            Button {
                                confirmSelection(for: bird.id)
                            } label: {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 32))
                                    .foregroundStyle(pendingSelection == .none ? .gray : .yellow)
                            }
                            .buttonStyle(.plain)
                            .padding(.bottom, 8)
                        }
                        .padding(16)
                        .frame(maxWidth: 320)
                        .background(.customLightBrown2)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: .black.opacity(0.2), radius: 18, x: 0, y: 8)
                        .onAppear {
                            pendingSelection = markService.status(forKey: bird.imageFileName)
                        }
                    }
                }
            }
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView {
                    if !appRouter.catalogRoute.isEmpty {
                        appRouter.catalogRoute.removeLast()
                    }
                }
            }
        }
    }
}

// MARK: - Helpers

extension RareBirdDetailView {
    private var isMarkButtonEnabled: Bool {
        guard let bird else { return false }
        return markService.status(forKey: bird.imageFileName) == .none
    }
    
    private func showMarkOverlay(with preselect: BirdMarkStatus) {
        pendingSelection = preselect == .none ? .met : preselect
        isMarkOverlayVisible = true
    }
    
    private func confirmSelection(for birdId: UUID) {
        guard pendingSelection != .none else { return }
        if let bird { markService.setStatus(pendingSelection, forKey: bird.imageFileName) }
        isMarkOverlayVisible = false
    }
    
    @ViewBuilder
    private func markOption(status: BirdMarkStatus, title: String) -> some View {
        let isSelected = pendingSelection == status
        VStack(spacing: 8) {
            Image(status == .met ? "selected" : "unselected")
                .resizable()
                .scaledToFit()
                .frame(width: 92, height: 92)
            Text(title)
                .font(.customFont(font: .regular, size: 14))
                .foregroundStyle(.customBlack)
        }
        .padding(12)
        .frame(width: 150, height: 150)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isSelected ? Color.customLightOrange : Color.clear, lineWidth: 3)
        )
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .onTapGesture { pendingSelection = status }
    }
}

// MARK: - Preview

#Preview("LightEN") {
    NavigationStack {
        RareBirdDetailView(birdId: RareBird.seed.first!.id)
            .environmentObject(AppRouter.shared)
            .environmentObject(TabbarService.shared)
            .environmentObject(BirdMarkService.shared)
    }
}
