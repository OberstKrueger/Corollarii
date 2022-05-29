import Foundation

enum CalculatorCharacter {
    case number(Decimal)
    case backspace
    case decimal
}

extension CalculatorCharacter {
    var characterValue: String {
        switch self {
        case .number(let number):
            return number.description
        case .backspace:
            return "⌫"
        case .decimal:
            return "."
        }
    }
}
