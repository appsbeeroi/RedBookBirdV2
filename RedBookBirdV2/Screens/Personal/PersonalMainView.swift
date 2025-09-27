import SwiftUI

// MARK: - Personal Main View

/// Главный экран личного кабинета
struct PersonalMainView: View {
    
    @EnvironmentObject private var appRouter: AppRouter
    @EnvironmentObject private var observationService: ObservationService
    @EnvironmentObject private var tabbarService: TabbarService
    
    var body: some View {
        @ObservedObject var appRouter = appRouter
        
        NavigationStack(path: $appRouter.personalRoute) {
            ZStack(alignment: .center) {
                BackGroundView()
                
                VStack(alignment: .center, spacing: 16) {
                    // Название экрана
                    VStack(alignment: .center, spacing: -32) {
                        Text("Personal observation")
                            .font(.customFont(font: .regular, size: 32))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        Text("diary")
                            .font(.customFont(font: .regular, size: 32))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                    
                    if observationService.hasObservations {
                        // Список наблюдений
                        ScrollView(showsIndicators: false) {
                            LazyVStack(alignment: .leading, spacing: 12) {
                                ForEach(observationService.observations) { observation in
                                    PersonalObservationCard(observation: observation)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            observationService.selectedObservation = observation
                                            appRouter.personalRoute.append(.observationDetail)
                                        }
                                }
                            }
                        }
                    } else {
                        // Empty State
                        Spacer()
                        
                        VStack(alignment: .center, spacing: 16) {
                            RoundedRectangle(cornerRadius: 35)
                                .fill(Color.white)
                                .frame(maxWidth: 300, maxHeight: 300, alignment: .center)
                                .overlay(
                                    VStack(spacing: 32) {
                                        Image(systemName: "xmark")
                                            .font(.system(size: 64, weight: .heavy))
                                            .foregroundStyle(.orange)
                                        Text("There's nothing here yet..")
                                            .font(.customFont(font: .regular, size: 20))
                                            .foregroundStyle(.customBlack)
                                    }
                                )
                        }
                        
                        Spacer()
                    }
                    
                    // Кнопка добавить птицу
                    Button {
                        // Очистить выбранную запись, чтобы форма не предзаполнялась
                        observationService.selectedObservation = nil
                        appRouter.personalRoute.append(.addObservation)
                    } label: {
                        Text("Add Bird")
                            .font(.customFont(font: .regular, size: 25))
                            .foregroundStyle(.customBlack)
                            .frame(maxWidth: .infinity, minHeight: 64)
                            .background(.customLightOrange)
                            .clipShape(Capsule())
                            .baselineOffset(-2)
                    }
                    .padding(.bottom, AppConfig.adaptiveTabbarBottomPadding + 4)
                }
                .padding(.horizontal)
            }
            .onAppear {
                tabbarService.isTabbarVisible = true
            }
            .navigationDestination(for: PersonalScreen.self) { screen in
                switch screen {
                case .main:
                    PersonalMainView()
                case .addObservation:
                    AddObservationView()
                case .observationDetail:
                    if let selected = observationService.selectedObservation {
                        PersonalObservationDetailView(observation: selected)
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview("LightEN") {
    PersonalMainView()
        .environmentObject(AppRouter.shared)
        .environmentObject(ObservationService.shared)
        .environmentObject(TabbarService.shared)
}
