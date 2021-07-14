import Foundation
import SwiftUI

/// Manager object.
class CorollariiManager: ObservableObject {
    // MARK: - Internal Properties
    fileprivate var calculatedTip: Decimal {
        if var calculated = Decimal(string: amount) {
            var rounded = Decimal()

            calculated *= (Decimal(percentage) / 100)
            NSDecimalRound(&rounded, &calculated, 2, .bankers)

            return rounded
        } else {
            return .nan
        }
    }

    fileprivate var calculatedTotal: Decimal {
        if let calculated = Decimal(string: amount) {
            return calculated + calculatedTip
        } else {
            return .nan
        }
    }

    // MARK: - Public Properties
    @Published var amount: String = "0" {
        didSet {
            switch amount.count {
            case 0:
                amount = "0"
            case 1:
                break
            default:
                if amount.first == "0" && amount.starts(with: "0.") == false {
                    amount = String(amount.dropFirst())
                }
                if let first = (amount.firstIndex(of: ".")), let second = amount.lastIndex(of: ".") {
                    if first != second { amount.remove(at: second) }
                }
            }

            
        }
    }

    @Published var round: Bool = false

    @Published var percentage: UInt = 15

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
            if let calculated = Decimal(string: amount) {
                return calculated + calculateTip()
            } else {
                return .nan
            }
        } else {
            return calculatedTotal
        }
    }
}
