import SwiftUI

// MARK: - Catalog Main View

/// Главный экран каталога
struct CatalogMainView: View {
    
    @EnvironmentObject private var appRouter: AppRouter
    @EnvironmentObject private var tabbarService: TabbarService
    @State private var searchText: String = ""
    @FocusState private var isSearchFocused: Bool
    @State private var isKeyboardVisible: Bool = false
    @State private var selectedBirdId: UUID? = nil
    
    // Фильтрованный список птиц по поисковой строке
    private var filteredBirds: [RareBird] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return RareBird.seed }
        return RareBird.seed.filter { bird in
            bird.commonName.lowercased().contains(query.lowercased())
        }
    }
    
    var body: some View {
        @ObservedObject var appRouter = appRouter
        
        NavigationStack(path: $appRouter.catalogRoute) {
            ZStack(alignment: .center) {
                BackGroundView()
                
                VStack(alignment: .center, spacing: 8) {
                    Text("Catalog of rare birds")
                        .font(.customFont(font: .regular, size: 32))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                    // Поисковая строка в стиле ячейки
                    HStack(alignment: .center, spacing: 8) {
                        Image("searchIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24, alignment: .center)
                            .foregroundColor(.customLightBrown)
                        
                        TextField("Search by name", text: $searchText)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .focused($isSearchFocused)
                            .font(.customFont(font: .regular, size: 20))
                            .foregroundStyle(.customBlack)
                            .baselineOffset(-2)
                        
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                                isSearchFocused = false
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.customLightBrown)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                    .background(.white)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
                    
                    ScrollView(showsIndicators: false) {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(filteredBirds) { bird in
                                RareBirdCard(bird: bird) {
                                    selectedBirdId = bird.id
                                    appRouter.catalogRoute.append(.detail)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, isKeyboardVisible ? 4 : AppConfig.adaptiveTabbarBottomPadding)
            }
            .onAppear {
                tabbarService.isTabbarVisible = true
            }
            // Сворачивание клавиатуры по тапу в любое место
            .contentShape(Rectangle())
            .onTapGesture {
                isSearchFocused = false
            }
            // Отслеживаем показ/скрытие клавиатуры, чтобы убирать нижний паддинг
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                isKeyboardVisible = true
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                isKeyboardVisible = false
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .navigationDestination(for: CatalogScreen.self) { screen in
                switch screen {
                case .main: CatalogMainView()
                case .detail:
                    if let id = selectedBirdId {
                        RareBirdDetailView(birdId: id)
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview("LightEN") {
    CatalogMainView()
        .environmentObject(AppRouter.shared)
        .environmentObject(TabbarService.shared)
}
