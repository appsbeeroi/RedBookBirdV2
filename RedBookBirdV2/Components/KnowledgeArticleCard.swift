import SwiftUI

// MARK: - Knowledge Article Card

struct KnowledgeArticleCard: View {
    let article: KnowledgeArticle
    let onTap: (() -> Void)?
    
    init(article: KnowledgeArticle, onTap: (() -> Void)? = nil) {
        self.article = article
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: {
            onTap?()
        }) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(article.title)
                        .font(.customFont(font: .regular, size: 16))
                        .foregroundStyle(.customBlack)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    Text(article.subtitle)
                        .font(.customFont(font: .regular, size: 14))
                        .foregroundStyle(.customBlack.opacity(0.6))
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if article.hasExternalLink {
                    Image(systemName: "link")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.blue)
                        .frame(width: 20, height: 20)
                }
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(Color.white)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 12) {
        KnowledgeArticleCard(
            article: KnowledgeArticle.seed[0],
            onTap: { print("Tapped article") }
        )
        
        KnowledgeArticleCard(
            article: KnowledgeArticle.seed[6], // Article with external link
            onTap: { print("Tapped article with link") }
        )
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
