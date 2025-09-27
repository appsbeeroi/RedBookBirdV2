import SwiftUI

// MARK: - History Main View

/// Главный экран истории
struct HistoryMainView: View {
    
    @EnvironmentObject private var appRouter: AppRouter
    @EnvironmentObject private var tabbarService: TabbarService
    @EnvironmentObject private var observationService: ObservationService
    
    @State private var isCalendarPresented: Bool = false
    @State private var selectedDate: Date = Date()
    @State private var selectedObservation: PersonalObservation? = nil
    
    // Уникальные виды по названию
    private var uniqueTitles: [String] {
        observationService.observations.map { $0.id.uuidString }
    }
    
    // Наблюдения на выбранную дату (по дню, без времени)
    private var observationsForSelectedDate: [PersonalObservation] {
        let cal = Calendar.current
        return observationService.observations.filter { cal.isDate($0.date, inSameDayAs: selectedDate) }
            .sorted(by: { $0.date > $1.date })
    }
    
    // Количество записей по дням недели (Пн..Вс)
    private var weeklyCounts: [Int] {
        var counts = Array(repeating: 0, count: 7)
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Monday
        for obs in observationService.observations {
            let weekday = calendar.component(.weekday, from: obs.date)
            // Swift: weekday 1=Sunday..7=Saturday; нам нужен 0=Mon..6=Sun
            let index = (weekday + 5) % 7
            counts[index] += 1
        }
        return counts
    }
    
    var body: some View {
        @ObservedObject var appRouter = appRouter
        
        NavigationStack(path: $appRouter.historyRoute) {
            ZStack(alignment: .center) {
                BackGroundView()
                
                VStack(alignment: .leading, spacing: 16) {
                    // Title
                    Text("History and statistics")
                        .font(.customFont(font: .regular, size: 32))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    if observationService.observations.isEmpty {
                        // Empty state
                        Spacer()
                        
                        VStack(spacing: 16) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 32)
                                    .fill(Color.white)
                                VStack(spacing: 16) {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 80, weight: .bold))
                                        .foregroundStyle(Color.orange)
                                    Text("There’s nothing here yet..")
                                        .font(.customFont(font: .regular, size: 20))
                                        .foregroundStyle(.customBlack)
                                }
                                .padding(.vertical, 40)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 300)
                            .padding(.horizontal, 32)
                        }
                        
                        Spacer()
                    } else {
                        ScrollView(.vertical) {
                            VStack(alignment: .leading, spacing: 20) {
                                // Unique species block
                                HStack(alignment: .center, spacing: 16) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Unique species")
                                            .font(.customFont(font: .regular, size: 18))
                                            .foregroundStyle(.customBlack)
                                        HStack(spacing: -12) {
                                            ForEach(observationService.observations.prefix(3)) { obs in
                                                PersonalObservationAvatar(imageFileName: obs.imageFileName)
                                            }
                                        }
                                    }
                                    Spacer()
                                    Text("\(uniqueTitles.count)")
                                        .font(.customFont(font: .regular, size: 32))
                                        .foregroundStyle(.customBlack)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 28))
                                
                                // Activity chart (data-driven)
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Activity chart")
                                        .font(.customFont(font: .regular, size: 18))
                                        .foregroundStyle(.customBlack)
                                    FakeLineChart(counts: weeklyCounts)
                                        .frame(height: 140)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 28))
                                
                                // Chronology header
                                HStack(alignment: .center) {
                                    Text("Chronology of\nobservations")
                                        .font(.customFont(font: .regular, size: 22))
                                        .foregroundStyle(.customBlack)
                                        .lineLimit(2)
                                    Spacer()
                                    Button {
                                        isCalendarPresented = true
                                    } label: {
                                        ZStack {
                                            Circle().fill(Color.white)
                                            Image(systemName: "calendar")
                                                .foregroundStyle(.yellow)
                                        }
                                        .frame(width: 44, height: 44)
                                    }
                                    .buttonStyle(.plain)
                                }
                                
                                // Observations list for selected date
                                VStack(spacing: 16) {
                                    if observationsForSelectedDate.isEmpty {
                                        Text("No observations on this date")
                                            .font(.customFont(font: .regular, size: 16))
                                            .foregroundStyle(.customBlack.opacity(0.6))
                                            .frame(maxWidth: .infinity, alignment: .center)
                                    } else {
                                        ForEach(observationsForSelectedDate) { obs in
                                            PersonalHistoryCard(observation: obs) {
                                                selectedObservation = obs
                                                observationService.selectedObservation = obs
                                                appRouter.historyRoute.append(.observationDetail)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.bottom, AppConfig.adaptiveTabbarBottomPadding)
                        }
                        .scrollIndicators(.hidden)
                    }
                }
                .padding(.horizontal)
                .sheet(isPresented: $isCalendarPresented) {
                    VStack {
                        DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                            .labelsHidden()
                            .padding()
                        Button("Done") { isCalendarPresented = false }
                            .padding(.bottom)
                    }
                    .presentationDetents([.height(420)])
                }
            }
            .onAppear {
                tabbarService.isTabbarVisible = true
            }
            .navigationDestination(for: HistoryScreen.self) { screen in
                switch screen {
                case .main:
                    EmptyView()
                case .observationDetail:
                    if let obs = selectedObservation {
                        PersonalObservationDetailView(observation: obs)
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview("LightEN") {
    HistoryMainView()
        .environmentObject(AppRouter.shared)
        .environmentObject(TabbarService.shared)
        .environmentObject(ObservationService.shared)
}
