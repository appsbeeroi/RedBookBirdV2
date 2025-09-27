import Foundation
import SwiftUI

// MARK: - Personal Observation Model

/// Модель пользовательской записи о наблюдении птицы
struct PersonalObservation: Identifiable, Hashable, Codable {
    /// Уникальный идентификатор записи
    let id: UUID
    /// Название птицы (пользовательский ввод)
    let title: String
    /// Место наблюдения
    let location: String
    /// Заметки пользователя
    let notes: String
    /// Дата наблюдения
    let date: Date
    /// Погодные условия
    let weather: WeatherCondition
    /// Тип местности
    let habitat: HabitatType
    /// Фото птицы (имя файла в Documents или nil если нет)
    let imageFileName: String?
    
    init(
        id: UUID = UUID(),
        title: String,
        location: String,
        notes: String,
        date: Date,
        weather: WeatherCondition,
        habitat: HabitatType,
        imageFileName: String? = nil
    ) {
        self.id = id
        self.title = title
        self.location = location
        self.notes = notes
        self.date = date
        self.weather = weather
        self.habitat = habitat
        self.imageFileName = imageFileName
    }
}

// MARK: - Weather Conditions

enum WeatherCondition: String, CaseIterable, Codable {
    case clear = "Clear"
    case partlyCloudy = "Partly Cloudy"
    case cloudy = "Cloudy"
    case rain = "Rain"
    case snow = "Snow"
    case fog = "Fog"
    
    var displayName: String {
        return rawValue
    }
}

// MARK: - Habitat Types

enum HabitatType: String, CaseIterable, Codable {
    case forest = "Forest"
    case field = "Field"
    case water = "Water"
    case city = "City"
    case grassland = "Grassland"
    
    var displayName: String {
        return rawValue
    }
    
    var emoji: String {
        switch self {
        case .forest: return "🌲"
        case .field: return "🏞️"
        case .water: return "🌊"
        case .city: return "🏙️"
        case .grassland: return "🌾"
        }
    }
}
