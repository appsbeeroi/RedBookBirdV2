import SwiftUI
import PhotosUI

// MARK: - Add Observation View

/// Экран добавления новой записи о птице
struct AddObservationView: View {
    @EnvironmentObject private var appRouter: AppRouter
    @EnvironmentObject private var observationService: ObservationService
    @EnvironmentObject private var tabbarService: TabbarService
    
    // MARK: - Form State
    @State private var title: String = ""
    @State private var location: String = ""
    @State private var notes: String = ""
    @State private var selectedDate: Date = Date()
    @State private var selectedWeather: WeatherCondition? = nil
    @State private var selectedHabitat: HabitatType? = nil
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var imageData: Data? = nil
    @FocusState private var isEditing: Bool
    
    // Режим редактирования
    @State private var isEditMode: Bool = false
    
    // Computed: все ли поля заполнены
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        selectedWeather != nil &&
        selectedHabitat != nil
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            BackGroundView()
            
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    
                    // Image Picker
                    PhotosPicker(selection: $selectedImage, matching: .images) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 120, height: 120)
                            
                            if let imageData, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                    .onChange(of: selectedImage) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                imageData = data
                            }
                        }
                    }
                    
                    // Calendar
                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    // Form Fields
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // Title
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title")
                                .font(.customFont(font: .regular, size: 16))
                                .foregroundStyle(.customBlack)
                            TextField("Write here..", text: $title)
                                .font(.customFont(font: .regular, size: 16))
                                .padding()
                                .background(Color.white)
                                .clipShape(Capsule())
                                .focused($isEditing)
                        }
                        
                        // Location
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Location")
                                .font(.customFont(font: .regular, size: 16))
                                .foregroundStyle(.customBlack)
                            TextField("Write here..", text: $location)
                                .font(.customFont(font: .regular, size: 16))
                                .padding()
                                .background(Color.white)
                                .clipShape(Capsule())
                                .focused($isEditing)
                        }
                        
                        // Notes
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes")
                                .font(.customFont(font: .regular, size: 16))
                                .foregroundStyle(.customBlack)
                            TextField("Write here..", text: $notes, axis: .vertical)
                                .font(.customFont(font: .regular, size: 16))
                                .lineLimit(1...5)
                                .padding()
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .focused($isEditing)
                        }
                        
                        // Weather
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Weather")
                                .font(.customFont(font: .regular, size: 16))
                                .foregroundStyle(.customBlack)
                            
                            FlowRows(spacing: 8, rowSpacing: 8) {
                                ForEach(WeatherCondition.allCases, id: \.self) { weather in
                                    Button {
                                        selectedWeather = weather
                                    } label: {
                                        HStack(spacing: 6) {
                                            Text(weatherEmoji(weather))
                                            Text(weather.displayName)
                                                .font(.customFont(font: .regular, size: 14))
                                                .foregroundStyle(.customBlack)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.8)
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background((selectedWeather == weather ? Color.customLightOrange : Color.customLightOrange.opacity(0.25)))
                                        .clipShape(Capsule())
                                        .contentShape(Capsule())
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        
                        // Habitat
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Habitat")
                                .font(.customFont(font: .regular, size: 16))
                                .foregroundStyle(.customBlack)
                            
                            FlowRows(spacing: 8, rowSpacing: 8) {
                                ForEach(HabitatType.allCases, id: \.self) { habitat in
                                    Button {
                                        selectedHabitat = habitat
                                    } label: {
                                        HStack(spacing: 6) {
                                            Text(habitat.emoji)
                                            Text(habitat.displayName)
                                                .font(.customFont(font: .regular, size: 14))
                                                .foregroundStyle(.customBlack)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.8)
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background((selectedHabitat == habitat ? Color.customLightOrange : Color.customLightOrange.opacity(0.25)))
                                        .clipShape(Capsule())
                                        .contentShape(Capsule())
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    
                    // Done Button
                    Button {
                        saveObservation()
                    } label: {
                        Text("Done")
                            .font(.customFont(font: .regular, size: 26))
                            .foregroundStyle(.customBlack)
                            .frame(maxWidth: .infinity, minHeight: 70)
                            .background(isFormValid ? Color.customLightOrange : Color.customLightGray.opacity(0.6))
                            .clipShape(Capsule())
                    }
                    .disabled(!isFormValid)
                    .padding(.top, 20)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                .background(
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture { isEditing = false }
                )
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .onAppear {
            tabbarService.isTabbarVisible = false
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView {
                    if !appRouter.personalRoute.isEmpty {
                        appRouter.personalRoute.removeLast()
                    }
                }
            }
        }
        .onAppear {
            // Предзаполнение полей, если редактируем существующую запись
            if let obs = observationService.selectedObservation {
                if !isEditMode { // чтобы не перезаписывать при повторных appear
                    isEditMode = true
                    title = obs.title
                    location = obs.location
                    notes = obs.notes
                    selectedDate = obs.date
                    selectedWeather = obs.weather
                    selectedHabitat = obs.habitat
                    if let file = obs.imageFileName,
                       let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        let url = docs.appendingPathComponent(file)
                        if let data = try? Data(contentsOf: url) {
                            imageData = data
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Actions
    
    private func saveObservation() {
        guard isFormValid,
              let weather = selectedWeather,
              let habitat = selectedHabitat else { return }
        
        // Сохранить изображение в Documents (если новое выбрано)
        var newImageFileName: String? = nil
        if let imageData = imageData, selectedImage != nil {
            newImageFileName = saveImageToDocuments(imageData)
        }
        
        if isEditMode, var existing = observationService.selectedObservation {
            // Обновление существующей записи
            existing = PersonalObservation(
                id: existing.id,
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                location: location.trimmingCharacters(in: .whitespacesAndNewlines),
                notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
                date: selectedDate,
                weather: weather,
                habitat: habitat,
                imageFileName: newImageFileName ?? existing.imageFileName
            )
            observationService.updateObservation(existing)
        } else {
            // Создание новой записи
            let observation = PersonalObservation(
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                location: location.trimmingCharacters(in: .whitespacesAndNewlines),
                notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
                date: selectedDate,
                weather: weather,
                habitat: habitat,
                imageFileName: newImageFileName
            )
            observationService.addObservation(observation)
        }
        
        // Возврат на главный экран Personal
        if !appRouter.personalRoute.isEmpty {
            appRouter.personalRoute.removeLast()
        }
    }
    
    private func saveImageToDocuments(_ data: Data) -> String? {
        let fileName = "\(UUID().uuidString).jpg"
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let fileURL = documentsPath.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            return fileName
        } catch {
            print("Error saving image: \(error)")
            return nil
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

// MARK: - FlowRows Layout

struct FlowRows: Layout {
    var spacing: CGFloat = 8
    var rowSpacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var rowHeight: CGFloat = 0
        
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if currentX + size.width > maxWidth {
                currentX = 0
                currentY += rowHeight + rowSpacing
                rowHeight = 0
            }
            rowHeight = max(rowHeight, size.height)
            currentX += size.width + spacing
        }
        return CGSize(width: maxWidth, height: currentY + rowHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let maxWidth = bounds.width
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var rowHeight: CGFloat = 0
        
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if currentX + size.width > maxWidth {
                currentX = 0
                currentY += rowHeight + rowSpacing
                rowHeight = 0
            }
            let origin = CGPoint(x: bounds.minX + currentX, y: bounds.minY + currentY)
            view.place(at: origin, proposal: ProposedViewSize(width: size.width, height: size.height))
            currentX += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

// MARK: - Preview

#Preview("LightEN") {
    NavigationStack {
        AddObservationView()
            .environmentObject(AppRouter.shared)
            .environmentObject(ObservationService.shared)
            .environmentObject(TabbarService.shared)
    }
}
