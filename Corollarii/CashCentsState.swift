import GameplayKit
import os

class CashCentsState: GKState {
    enum Count {
        case zero
        case one
        case two
    }

    /// System logger.
    var logger = Logger(subsystem: "technology.krueger.corollarii", category: "cash")

    /// Number of decimal points currently present.
    var position: Count = .zero {
        didSet {
            switch position {
            case .zero: logger.info("Cents position: 0")
            case .one: logger.info("Cents position: 1")
            case .two: logger.info("Cents position: 2")
            }
        }
    }

    override func didEnter(from previousState: GKState?) {
        logger.info("Entered new state: cents.")
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == CashDollarsState.self
    }

    func decrement() {
        switch position {
        case .zero:
            stateMachine?.enter(CashDollarsState.self)
        case .one:
            position = .zero
        case .two:
            position = .one
        }
    }

    func increment() {
        switch position {
        case .zero:
            position = .one
        case .one:
            position = .two
        case .two:
            fatalError("Increment command given while CashCentsState.Count is .two.")
        }
    }
}
