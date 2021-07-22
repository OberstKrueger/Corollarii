import Foundation
import SwiftUI

/// Manager object.
class CorollariiManager: ObservableObject {
    // MARK: - Internal Properties
    fileprivate var calculatedTip: Decimal {
        if var calculated = Decimal(string: displayAmount) {
            var rounded = Decimal()

            calculated *= (Decimal(percentage) / 100)
            NSDecimalRound(&rounded, &calculated, 2, .bankers)

            return rounded
        } else {
            return .nan
        }
    }

    fileprivate var calculatedTotal: Decimal {
        if let calculated = Decimal(string: displayAmount) {
            return calculated + calculatedTip
        } else {
            return .nan
        }
    }

    // MARK: - Public Properties
    @Published var amount: [CalculatorCharacters] = [] {
        didSet {
            displayAmount = amount.isEmpty ? "0.00" : amount.map({String($0.rawValue)}).joined()
        }
    }

    @Published var round: Bool = false

    @Published var percentage: UInt = 15

    var displayAmount: String = "0.00"

    // MARK: - Public Methods
    func calculateTip() -> Decimal {
        if round {
            var rounded = Decimal()
            var tempTotal = calculatedTotal

            NSDecimalRound(&rounded, &tempTotal, 0, .up)

            return calculatedTip + rounded - calculatedTotal
        } else {
            return calculatedTip
        }

    }

    func calculateTotal() -> Decimal {
        if round {
            if let calculated = Decimal(string: displayAmount) {
                return calculated + calculateTip()
            } else {
                return .nan
            }
        } else {
            return calculatedTotal
        }
    }

    func keypress(key: CalculatorCharacters) {
        amount.append(key)
    }

    enum CalculatorCharacters: String {
        case one     = "1"
        case two     = "2"
        case three   = "3"
        case four    = "4"
        case five    = "5"
        case six     = "6"
        case seven   = "7"
        case eight   = "8"
        case nine    = "9"
        case zero    = "0"
        case decimal = "."
    }
}
