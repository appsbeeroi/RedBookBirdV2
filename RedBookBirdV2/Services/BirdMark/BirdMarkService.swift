import Foundation

// MARK: - Mark Status

enum BirdMarkStatus: String, Codable {
    case none
    case met
    case wantToFind
}

// MARK: - Service

@MainActor
final class BirdMarkService: ObservableObject {
    static let shared = BirdMarkService()
    private init() {
        // Eager load persisted data once to avoid publishing during view updates
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([String: BirdMarkStatus].self, from: data) {
            birdIdToStatus = decoded
        }
    }
    
    private let storageKey = "bird_mark_status_storage"
    
    /// Кэш состояния в памяти для быстрого доступа
    /// Ключом служит стабильный идентификатор записи (например, имя файла изображения)
    @Published private(set) var birdIdToStatus: [String: BirdMarkStatus] = [:]
    
    // MARK: - Public API
    
    // Новый API: стабильный ключ (imageFileName)
    func status(forKey key: String) -> BirdMarkStatus {
        return birdIdToStatus[key] ?? .none
    }
    
    // Сохранение по стабильному ключу
    func setStatus(_ status: BirdMarkStatus, forKey key: String) {
        birdIdToStatus[key] = status
        birdIdToStatus = birdIdToStatus
        persist()
    }
    
    // Старый API (оставляем для совместимости, но лучше не использовать)
    func status(for birdId: UUID) -> BirdMarkStatus {
        return status(forKey: birdId.uuidString)
    }
    
    func setStatus(_ status: BirdMarkStatus, for birdId: UUID) {
        setStatus(status, forKey: birdId.uuidString)
    }
    
    // MARK: - Persistence
    
    private func persist() {
        if let data = try? JSONEncoder().encode(birdIdToStatus) {
            UserDefaults.standard.set(data, forKey: storageKey)
            UserDefaults.standard.synchronize()
        }
    }
}


