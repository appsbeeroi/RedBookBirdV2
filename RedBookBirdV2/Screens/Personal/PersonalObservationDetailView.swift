import SwiftUI

// MARK: - Personal Observation Detail View

struct PersonalObservationDetailView: View {
    @EnvironmentObject private var appRouter: AppRouter
    @EnvironmentObject private var tabbarService: TabbarService
    @EnvironmentObject private var observationService: ObservationService
    @Environment(\.dismiss) private var dismiss
    
    let observation: PersonalObservation
    
    @State private var uiImage: UIImage? = nil
    @State private var showDeleteAlert: Bool = false
    @State private var currentObservation: PersonalObservation
    
    init(observation: PersonalObservation) {
        self.observation = observation
        self._currentObservation = State(initialValue: observation)
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            BackGroundView()
            
            VStack(alignment: .center, spacing: 0) {
                // Картинка
                imageHeader
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 16) {
                        // Локация
                        HStack(spacing: 8) {
                            Image(systemName: "mappin.and.ellipse")
                            Text(currentObservation.location)
                                .font(.customFont(font: .regular, size: 18))
                                .foregroundStyle(.customBlack)
                        }
                        
                        // Дата
                        HStack(spacing: 8) {
                            Image(systemName: "calendar")
                            Text(dateString)
                                .font(.customFont(font: .regular, size: 18))
                                .foregroundStyle(.customBlack)
                        }
                        
                        // Погода/местность чипы
                        HStack(spacing: 12) {
                            HStack(spacing: 6) {
                                Text(weatherEmoji(currentObservation.weather))
                                Text(currentObservation.weather.displayName)
                                    .font(.customFont(font: .regular, size: 14))
                                    .foregroundStyle(.customBlack)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.customLightOrange.opacity(0.25))
                            .clipShape(Capsule())
                            
                            HStack(spacing: 6) {
                                Text(currentObservation.habitat.emoji)
                                Text(currentObservation.habitat.displayName)
                                    .font(.customFont(font: .regular, size: 14))
                                    .foregroundStyle(.customBlack)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.customLightOrange.opacity(0.25))
                            .clipShape(Capsule())
                        }
                        
                        // Notes
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Notes")
                                .font(.customFont(font: .regular, size: 16))
                                .foregroundStyle(.customBlack.opacity(0.5))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(currentObservation.notes)
                                .font(.customFont(font: .regular, size: 20))
                                .foregroundStyle(.customBlack)
                        }
                    }
                    .padding(.top, 12)
                }
                .scrollIndicators(.hidden)
            }
            .padding(.horizontal)
        }
        .onAppear {
            tabbarService.isTabbarVisible = false
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView {
                    // Универсальный возврат через dismiss
                    dismiss()
                }
            }
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    // Edit -> push AddObservationView с предзаполненными данными
                    observationService.selectedObservation = currentObservation
                    appRouter.personalRoute.append(.addObservation)
                } label: {
                    Image("edit")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32, alignment: .center)
                }
                .buttonStyle(.plain)
                
                Button { showDeleteAlert = true } label: {
                    Image("deleteView")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32, alignment: .center)
                }
                .buttonStyle(.plain)
            }
        }
        .alert("Delete", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                observationService.removeObservation(currentObservation)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to remove this bird?")
        }
        .onAppear(perform: loadImage)
        .onReceive(observationService.$observations) { _ in
            // Обновляем данные при изменении в ObservationService
            if let updated = observationService.observations.first(where: { $0.id == currentObservation.id }) {
                currentObservation = updated
                loadImage()
            }
        }
    }
    
    private var imageHeader: some View {
        Group {
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 260)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.white.opacity(0.6))
                    .frame(height: 260)
            }
        }
    }
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: currentObservation.date)
    }
    
    private func loadImage() {
        guard let fileName = currentObservation.imageFileName,
              let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let url = documents.appendingPathComponent(fileName)
        if let data = try? Data(contentsOf: url), let img = UIImage(data: data) {
            uiImage = img
        }
    }
    
    // MARK: - Helpers
    private func weatherEmoji(_ weather: WeatherCondition) -> String {
        switch weather {
        case .clear: return "☀️"
        case .partlyCloudy: return "🌤️"
        case .cloudy: return "☁️"
        case .rain: return "🌧️"
        case .snow: return "❄️"
        case .fog: return "🌫️"
        }
    }
}

// MARK: - Preview

#Preview("LightEN") {
    NavigationStack {
        PersonalObservationDetailView(
            observation: PersonalObservation(
                title: "Syrian Starling",
                location: "Forest near Lake Como, Italy",
                notes: "Today I spotted an ",
                date: Date(),
                weather: .clear,
                habitat: .forest,
                imageFileName: nil
            )
        )
        .environmentObject(AppRouter.shared)
        .environmentObject(TabbarService.shared)
        .environmentObject(ObservationService.shared)
    }
}


