import Foundation
import ActivityKit

@available(iOS 16.1, *)
public struct ChargingAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var soc: Double             // 0.0 - 1.0 (e.g. 0.82 for 82%)
        public var timeRemainingMins: Int  // in minutes
        public var speedKw: Double          // in kW (e.g. 82.5)
        public var costRm: Double           // total cost accrued
        public var isDarkMode: Bool

        public init(
            soc: Double,
            timeRemainingMins: Int,
            speedKw: Double,
            costRm: Double,
            isDarkMode: Bool = true
        ) {
            self.soc = soc
            self.timeRemainingMins = timeRemainingMins
            self.speedKw = speedKw
            self.costRm = costRm
            self.isDarkMode = isDarkMode
        }
    }

    public var sessionName: String

    public init(sessionName: String = "Active Charging") {
        self.sessionName = sessionName
    }
}
