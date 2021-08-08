import Foundation

class Defaults {
    // MARK: - Internal Properties
    let defaults = UserDefaults.standard

    var percentage: Int {
        get { defaults.integer(forKey: DefaultsStrings.percentage.rawValue) }
        set { defaults.set(newValue, forKey: DefaultsStrings.percentage.rawValue) }
    }

    var round: Bool {
        get { defaults.bool(forKey: DefaultsStrings.round.rawValue) }
        set { defaults.set(newValue, forKey: DefaultsStrings.round.rawValue) }
    }
}


/// String values for UserDefault keys.
fileprivate enum DefaultsStrings: String {
    case percentage = "Percentage"
    case round = "Round"
}
