import GameplayKit
import os

class CashDollarsState: GKState {

    /// System logger.
    var logger = Logger(subsystem: "technology.krueger.corollarii", category: "cash")

    override func didEnter(from previousState: GKState?) {
        logger.info("Entered new state: dollars.")
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == CashCentsState.self
    }
}
