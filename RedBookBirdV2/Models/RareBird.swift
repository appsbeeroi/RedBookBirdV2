import Foundation

// MARK: - RareBird Model

/// Модель редкой птицы для локального хранения в приложении
struct RareBird: Identifiable, Hashable, Codable {
    /// Уникальный идентификатор записи
    let id: UUID
    /// Имя файла изображения в ассетах (например, `img_1.png`)
    let imageFileName: String
    /// Название птицы (человеко-читаемое)
    let commonName: String
    /// Среда обитания / ареал
    let habitat: String
    /// Краткое описание, особенности и факты
    let summary: String
    let conservationStatus: String
    
    init(
        id: UUID = UUID(),
        imageFileName: String,
        commonName: String,
        habitat: String,
        summary: String,
        conservationStatus: String
    ) {
        self.id = id
        self.imageFileName = imageFileName
        self.commonName = commonName
        self.habitat = habitat
        self.summary = summary
        self.conservationStatus = conservationStatus
    }
}

// MARK: - Seed Data

extension RareBird {
    /// Предзаполненные 10 записей редких птиц
    static let seed: [RareBird] = [
        RareBird(
            imageFileName: "img_10",
            commonName: "Common Loon",
            habitat: "Clear northern lakes; boreal/temperate North America",
            summary: "Black head, checkerboard back; superb diver with eerie calls; fish-eater.",
            conservationStatus: "Vulnerable"
        ),
        RareBird(
            imageFileName: "img_9",
            commonName: "Mandarin Duck",
            habitat: "Woodland ponds & slow rivers; East Asia (introduced in Europe)",
            summary: "Striking male with ornate crest and sails; popular ornamental duck.",
            conservationStatus: "Recovering"
        ),
        RareBird(
            imageFileName: "img_8",
            commonName: "Peregrine Falcon",
            habitat: "Cliffs & cities worldwide",
            summary: "Slate-gray raptor; fastest animal on earth in dive; pigeon specialist.",
            conservationStatus: "Endangered"
        ),
        RareBird(
            imageFileName: "img_7",
            commonName: "Common Crane",
            habitat: "Marshes and wet meadows; Europe & Asia (migrates to Africa/India)",
            summary: "Tall gray crane with red crown patch; loud trumpeting; long migration.",
            conservationStatus: "Endangered"
        ),
        RareBird(
            imageFileName: "img_6",
            commonName: "Bald Eagle",
            habitat: "Coasts, lakes, large rivers; North America",
            summary: "Large sea-eagle; white head & tail; fish hunter.",
            conservationStatus: "Vulnerable"
        ),
        RareBird(
            imageFileName: "img_5",
            commonName: "Eurasian Eagle-Owl",
            habitat: "Rocky forests & cliffs; Europe/Asia/N. Africa",
            summary: "Massive owl with orange eyes and ear tufts; nocturnal apex predator.",
            conservationStatus: "Recovering"
        ),
        RareBird(
            imageFileName: "img_4",
            commonName: "Firecrest (Common Firecrest)",
            habitat: "Coniferous & mixed woodland; Europe & NW Africa",
            summary: "Tiny songbird; bold white eyebrow, black eye-stripe, orange crown.",
            conservationStatus: "Endangered"
        ),
        RareBird(
            imageFileName: "img_3",
            commonName: "Greylag Goose",
            habitat: "Wetlands, lakes, fields; Europe & W. Asia",
            summary: "Large gray goose with orange bill; ancestor of domestic goose.",
            conservationStatus: "Endangered"
        ),
        RareBird(
            imageFileName: "img_2",
            commonName: "White Stork",
            habitat: "Wetlands & farmlands; Europe/N. Africa/West Asia",
            summary: "Tall white stork with red bill/legs; often nests on buildings.",
            conservationStatus: "Vulnerable"
        ),
        RareBird(
            imageFileName: "img_1",
            commonName: "European Starling",
            habitat: "Towns, farms, open country; Eurasia (introduced in N. America)",
            summary: "Iridescent black with speckles; gifted mimic; forms murmurations.",
            conservationStatus: "Endangered"
        )
    ]
}
