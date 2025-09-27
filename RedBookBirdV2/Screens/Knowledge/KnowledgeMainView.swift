import SwiftUI

// MARK: - Knowledge Main View

/// Главный экран базы знаний
struct KnowledgeMainView: View {
    @EnvironmentObject private var appRouter: AppRouter
    @EnvironmentObject private var tabbarService: TabbarService
    
    @State private var selectedArticle: KnowledgeArticle? = nil
    
    private var articlesByCategory: [ArticleCategory: [KnowledgeArticle]] {
        Dictionary(grouping: KnowledgeArticle.seed) { $0.category }
    }
    
    var body: some View {
        @ObservedObject var appRouter = appRouter
        
        NavigationStack(path: $appRouter.knowledgeRoute) {
            ZStack(alignment: .center) {
                BackGroundView()
                
                VStack(alignment: .leading, spacing: 16) {
                    // Title
                    Text("Knowledge section")
                        .font(.customFont(font: .regular, size: 32))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    ScrollView(.vertical) {
                        // Categories and articles
                        ForEach(ArticleCategory.allCases, id: \.self) { category in
                            VStack(alignment: .leading, spacing: 0) {
                                // Category header
                                Text(category.displayName)
                                    .font(.customFont(font: .regular, size: 18))
                                    .foregroundStyle(.customBlack)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                // Articles in category
                                VStack(spacing: 8) {
                                    ForEach(articlesByCategory[category] ?? []) { article in
                                        KnowledgeArticleCard(article: article) {
                                            selectedArticle = article
                                            appRouter.knowledgeRoute.append(.articleDetail)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.bottom, AppConfig.adaptiveTabbarBottomPadding)
                    }
                    .padding(.horizontal)
                }
                .scrollIndicators(.hidden)
            }
            .onAppear {
                tabbarService.isTabbarVisible = true
            }
            .navigationDestination(for: KnowledgeScreen.self) { screen in
                switch screen {
                case .main:
                    EmptyView()
                case .articleDetail:
                    if let article = selectedArticle {
                        KnowledgeArticleDetailView(article: article)
                    } else {
                        EmptyView()
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview("LightEN") {
    KnowledgeMainView()
        .environmentObject(AppRouter.shared)
}
