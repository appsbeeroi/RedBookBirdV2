import SwiftUI

// MARK: - Knowledge Article Detail View

struct KnowledgeArticleDetailView: View {
    @EnvironmentObject private var appRouter: AppRouter
    @EnvironmentObject private var tabbarService: TabbarService
    
    let article: KnowledgeArticle
    
    var body: some View {
        ZStack(alignment: .center) {
            BackGroundView()
            
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 20) {
                    // Category badge
                    Text(article.category.displayName)
                        .font(.customFont(font: .regular, size: 14))
                        .foregroundStyle(.customBlack.opacity(0.6))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(Color.white.opacity(0.8)))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Title
                    Text(article.title)
                        .font(.customFont(font: .regular, size: 24))
                        .foregroundStyle(.customBlack)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Subtitle
                    Text(article.subtitle)
                        .font(.customFont(font: .regular, size: 16))
                        .foregroundStyle(.customBlack.opacity(0.7))
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Content
                    Text(article.content)
                        .font(.customFont(font: .regular, size: 16))
                        .foregroundStyle(.customBlack)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // External link button if available
                    if article.hasExternalLink, let link = article.externalURL, let url = URL(string: link) {
                        Button(action: {
                            UIApplication.shared.open(url)
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "link")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Read more online")
                                    .font(.customFont(font: .regular, size: 16))
                            }
                            .foregroundStyle(.blue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Capsule().fill(Color.blue.opacity(0.1)))
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
        }
        .onAppear {
            tabbarService.isTabbarVisible = false
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView {
                    if !appRouter.knowledgeRoute.isEmpty {
                        appRouter.knowledgeRoute.removeLast()
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        KnowledgeArticleDetailView(
            article: KnowledgeArticle.seed[0]
        )
        .environmentObject(AppRouter.shared)
        .environmentObject(TabbarService.shared)
    }
}
