import Foundation

struct Cash {
    // MARK: - Internal Properties
    /// The amount of cents inputted.
    fileprivate var cents: [CalculatorCharacters] = []

    /// If a decimal is present..
    fileprivate var decimal: Bool = false

    /// The amount of dollars inputted.
    fileprivate var dollars: [CalculatorCharacters] = []

    // MARK: - Public Properties
    var total: String {
        let calculatedDollars: String = dollars.isEmpty ? "0" : dollars.map({$0.rawValue}).joined()

        if decimal {
            return calculatedDollars + "." + (cents.isEmpty ? "00" : cents.map({$0.rawValue}).joined())
        } else {
            return calculatedDollars
        }
    }

    var totalDecimal: Decimal {
        let calculatedDollars: String = dollars.isEmpty ? "0" : dollars.map({$0.rawValue}).joined()

        if decimal {
            let decimalString: String = calculatedDollars + "." + (cents.isEmpty ? "00" : cents.map({$0.rawValue}).joined())

            return Decimal(string: decimalString)!
        } else {
            return Decimal(string: calculatedDollars)!
        }
    }

    var totalDisplay: String {
        let calculatedDollars: String = dollars.isEmpty ? "0" : dollars.map({$0.rawValue}).joined()

        if decimal {
            return calculatedDollars + "." + cents.map({$0.rawValue}).joined()
        } else {
            return calculatedDollars
        }
    }

    // MARK: - Public Methods
    mutating func input(key: CalculatorCharacters) {
        switch key {
        case .zero:
            if decimal {
                if cents.count < 2 { cents.append(key) }
            } else {
                if dollars != [.zero] {
                    dollars.append(key)
                }
            }
        case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            if decimal {
                if cents.count < 2 { cents.append(key) }
            } else {
                if dollars == [.zero] {
                    dollars[0] = key
                } else {
                    dollars.append(key)
                }
            }
        case .decimal:
            if decimal == false { decimal = true }
        }
    }

    mutating func remove() {
        if decimal {
            if cents.count > 0 {
                cents.removeLast()
            } else {
                decimal = false
            }
        } else {
            if dollars.count > 0 {
                dollars.removeLast()
            }
        }
    }
}
