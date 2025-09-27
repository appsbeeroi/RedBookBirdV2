import SwiftUI

struct RareBirdCard: View {
    /// Модель птицы для отображения
    let bird: RareBird
    /// Необязательное действие по нажатию (обрабатывается снаружи по желанию)
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            // Фото птицы в круге
            Image(bird.imageFileName)
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
            
            VStack(alignment: .leading, spacing: 0) {
                // Название птицы
                Text(bird.commonName)
                    .font(.customFont(font: .regular, size: 20))
                    .foregroundColor(.customBlack)
                    .lineLimit(1)
                
                // Тег(и): пока отображаем ареал как чип
                Text(bird.conservationStatus)
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
        .contentShape(Rectangle())
        .onTapGesture { onTap?() }
    }
}

// MARK: - Preview

#Preview("LightEN") {
    RareBirdCard(bird: RareBird.seed.first!)
        .padding()
        .background(.black)
}
