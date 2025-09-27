import SwiftUI

// MARK: - Personal History Card

struct PersonalHistoryCard: View {
    let observation: PersonalObservation
    let onTap: (() -> Void)?
    
    @State private var loadedImage: UIImage? = nil
    
    init(observation: PersonalObservation, onTap: (() -> Void)? = nil) {
        self.observation = observation
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: { onTap?() }) {
            HStack(spacing: 12) {
                // Avatar
                Group {
                    if let img = loadedImage {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                    } else {
                        ZStack {
                            Color.white.opacity(0.8)
                            Image(systemName: "photo")
                                .font(.system(size: 28, weight: .medium))
                                .foregroundStyle(.customBlack.opacity(0.4))
                        }
                    }
                }
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                
                VStack(alignment: .leading, spacing: -4) {
                    Text(observation.title)
                        .font(.customFont(font: .regular, size: 22))
                        .foregroundStyle(.customBlack)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    HStack(spacing: 8) {
                        Image(systemName: "calendar")
                        Text(dateString)
                            .font(.customFont(font: .regular, size: 14))
                    }
                    .foregroundStyle(.customBlack)
                    
                    HStack(spacing: 8) {
                        Image(systemName: "mappin.and.ellipse")
                        Text(observation.location)
                            .font(.customFont(font: .regular, size: 14))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    .foregroundStyle(.customBlack)
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.white)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(.plain)
        .onAppear(perform: loadImage)
    }
    
    private var dateString: String {
        let f = DateFormatter()
        f.dateFormat = "dd.MM.yyyy"
        return f.string(from: observation.date)
    }
    
    private func loadImage() {
        guard let fileName = observation.imageFileName,
              let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let url = documents.appendingPathComponent(fileName)
        if let data = try? Data(contentsOf: url), let img = UIImage(data: data) {
            loadedImage = img
        }
    }
}

// MARK: - Avatar helper

struct PersonalObservationAvatar: View {
    let imageFileName: String?
    @State private var image: UIImage? = nil
    
    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    Color.white.opacity(0.8)
                    Image(systemName: "photo")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.customBlack.opacity(0.4))
                }
            }
        }
        .frame(width: 40, height: 40)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.white, lineWidth: 3))
        .onAppear(perform: load)
    }
    
    private func load() {
        guard let fileName = imageFileName,
              let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let url = documents.appendingPathComponent(fileName)
        if let data = try? Data(contentsOf: url), let img = UIImage(data: data) {
            image = img
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 12) {
        PersonalHistoryCard(
            observation: PersonalObservation(
                title: "Syrian Starling",
                location: "Forest near Lake Como, Italy",
                notes: "Beautiful bird spotted in the morning",
                date: Date(),
                weather: .clear,
                habitat: .forest,
                imageFileName: nil
            ),
            onTap: { print("Tapped history card") }
        )
        
        PersonalObservationAvatar(imageFileName: nil)
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
