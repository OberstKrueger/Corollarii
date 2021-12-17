import Foundation
import SwiftUI

/// Manager object.
class CorollariiManager: ObservableObject {
    // MARK: - Initializations
    init() {
        percentage = defaults.percentage
        round = defaults.round
    }

    // MARK: - Internal Properties
    fileprivate let defaults = Defaults()

    // MARK: - Public Properties
    /// Cash value from user input.
    @Published var cash = Cash()

    /// Tip percentage.
    @Published var percentage: Int {
        didSet { defaults.percentage = percentage }
    }

    /// User toggleable rounding of the total.
    @Published var round: Bool {
        didSet { defaults.round = round }
    }

    /// Tip calculated based on current percentage.
    var calculatedTip: Decimal {
        var calculated = cash.totalDecimal * (Decimal(percentage) / 100)
        var rounded = Decimal()

        NSDecimalRound(&rounded, &calculated, 2, .bankers)

        return rounded
    }

    /// Total calculated with standard tip.
    var calculatedTotal: Decimal {
        return cash.totalDecimal + calculatedTip
    }

    /// Tip calculated based on current percentage, rounding up so total is whole.
    var roundedTip: Decimal {
        var rounded = Decimal()
        var temptTotal = calculatedTotal

        NSDecimalRound(&rounded, &temptTotal, 0, .up)

        return calculatedTip + rounded - calculatedTotal
    }

    /// Total calculated with tip to round up the value to a whole number.
    var roundedTotal: Decimal {
        return cash.totalDecimal + roundedTip
    }

    // MARK: - Public Methods
    /// User-input from keyboard.
    func keypress(key: CalculatorCharacters) {
        cash.input(key: key)
    }
}
