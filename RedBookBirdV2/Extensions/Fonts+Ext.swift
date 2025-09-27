import SwiftUI

// MARK: - Custom Font Enum
/// Перечисление для управления кастомными шрифтами приложения
enum BalooBhaina: String {
    case regular = "BalooBhaina-Regular"
}

// MARK: - Font Extension
/// Расширение для Font с удобным методом создания кастомных шрифтов
extension Font {
    /// Создает кастомный шрифт с указанным размером
    /// - Parameters:
    ///   - font: Тип шрифта из enum BalooBhaina
    ///   - size: Размер шрифта
    /// - Returns: SwiftUI.Font с кастомным шрифтом
    static func customFont(font: BalooBhaina, size: CGFloat) -> SwiftUI.Font {
        .custom(font.rawValue, size: size)
    }
}
