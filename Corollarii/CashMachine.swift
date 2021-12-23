import GameplayKit

class CashMachine: GKStateMachine, ObservableObject {
    init() {
        let cents = CashCentsState()
        let dollars = CashDollarsState()

        percentage = defaults.percentage
        round = defaults.round

        super.init(states: [cents, dollars])

        _ = self.enter(CashDollarsState.self)
    }

    /// User defaults.
    let defaults = Defaults()

    /// Cash value from user input.
    @Published var input: Decimal = 0

    /// Tip percentage.
    @Published var percentage: Int {
        didSet {
            defaults.percentage = percentage
        }
    }

    /// User toggleable rounding of the total.
    @Published var round: Bool {
        didSet {
            defaults.round = round
        }
    }

    /// Tip calculated based on current percentage.
    var calculatedTip: Decimal {
        var calculated = input * (Decimal(percentage) / 100)
        var rounded = Decimal()

        NSDecimalRound(&rounded, &calculated, 2, .bankers)

        return rounded
    }

    /// Total calculated with standard tip.
    var calculatedTotal: Decimal {
        return input + calculatedTip
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
        return input + roundedTip
    }

    /// The displayed value for the user input field.
    var displayValue: String {
        switch currentState {
        case let state as CashCentsState:
            switch state.position {
            case .zero:
                return "\(input.description)."
            case .one:
                let formatter = NumberFormatter()

                formatter.minimumIntegerDigits = 1
                formatter.minimumFractionDigits = 1
                formatter.maximumFractionDigits = 1

                return formatter.string(from: input as NSNumber)!
            case .two:
                let formatter = NumberFormatter()

                formatter.minimumIntegerDigits = 1
                formatter.minimumFractionDigits = 2
                formatter.maximumFractionDigits = 2

                return formatter.string(from: input as NSNumber)!
            }
        case is CashDollarsState:
            return input.description
        default:
            return "invalid input: \(input.description)"
        }
    }

    func keypress(key: CalculatorCharacters) {
        switch currentState {
        case let state as CashCentsState:
            switch key {
            case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero:
                switch state.position {
                case .zero:
                    input += (Decimal(string: key.rawValue) ?? 0) / 10
                    state.increment()
                case .one:
                    input += (Decimal(string: key.rawValue) ?? 0) / 100
                    state.increment()
                case .two:
                    break
                }
            case .backspace:
                var rounded = Decimal()

                switch state.position {
                case .zero:
                    state.decrement()
                    input = input // Triggers view update.
                case .one:
                    state.decrement()
                    NSDecimalRound(&rounded, &input, 0, .bankers)
                    input = rounded
                case .two:
                    state.decrement()
                    NSDecimalRound(&rounded, &input, 1, .bankers)
                    input = rounded
                }
            case .decimal:
                break // Nothing does happen, because nothing should happen.
            }
        case is CashDollarsState:
            switch key {
            case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
                input = (input * 10) + (Decimal(string: key.rawValue) ?? 0)
            case .zero:
                input *= 10
            case .backspace:
                var reduced = input / 10
                var result = Decimal()

                NSDecimalRound(&result, &reduced, 0, .down)

                input = result
            case .decimal:
                enter(CashCentsState.self)
                input = input // Triggers view update.
            }
        default:
            break
        }
    }
}
