import GameplayKit

class CashMachine: ObservableObject {
    init() {
        percentage = defaults.percentage
        round = defaults.round
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

    /// Current input state.
    var state: CashState = .dollars

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
        switch state {
        case .centsZero:
            return "\(input.description)."
        case .centsOne:
            let formatter = NumberFormatter()

            formatter.minimumIntegerDigits = 1
            formatter.minimumFractionDigits = 1
            formatter.maximumFractionDigits = 1

            return formatter.string(from: input as NSNumber)!
        case .centsTwo:
            let formatter = NumberFormatter()

            formatter.minimumIntegerDigits = 1
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2

            return formatter.string(from: input as NSNumber)!
        case .dollars:
            return input.description
        }
    }

    func keypress(key: CalculatorCharacter) {
        switch (key, state) {
        case (.number(let number), .centsZero):
            input += number / 10
            state = .centsOne
        case (.number(let number), .centsOne):
            input += number / 100
            state = .centsTwo
        case (.number(let number), .centsTwo):
            break // Nothing does happen, because nothing should happen.
        case (.number(let number), .dollars):
            input = (input * 10) + number
        case (.backspace, .centsZero):
            input = input // Triggers view update.
            state = .dollars
        case (.backspace, .centsOne):
            var rounded = Decimal()
            NSDecimalRound(&rounded, &input, 0, .down)
            input = rounded
            state = .centsZero
        case (.backspace, .centsTwo):
            var rounded = Decimal()
            NSDecimalRound(&rounded, &input, 1, .down)
            input = rounded
            state = .centsOne
        case (.backspace, .dollars):
            var reduced = input / 10
            var result = Decimal()
            NSDecimalRound(&result, &reduced, 0, .down)
            input = result
        case (.decimal, .centsZero):
            break // Nothing does happen, because nothing should happen.
        case (.decimal, .centsOne):
            break // Nothing does happen, because nothing should happen.
        case (.decimal, .centsTwo):
            break // Nothing does happen, because nothing should happen.
        case (.decimal, .dollars):
            input = input // Triggers view update.
            state = .centsZero
        }
    }
}
