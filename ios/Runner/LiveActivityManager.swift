import Foundation
import ActivityKit
import Flutter

@available(iOS 16.1, *)
struct ChargingAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var soc: Double
        var timeRemainingMins: Int
        var speedKw: Double
        var costRm: Double
        var isDarkMode: Bool
    }
    
    var sessionName: String
}

class LiveActivityManager {
    static let shared = LiveActivityManager()
    
    private init() {}
    
    private var currentActivity: Any? = nil
    
    func startLiveActivity(soc: Double, timeRemainingMins: Int, speedKw: Double, costRm: Double, isDarkMode: Bool) {
        if #available(iOS 16.1, *) {
            // End any active activity first
            stopLiveActivity()
            
            let attributes = ChargingAttributes(sessionName: "Active Charging")
            let initialContentState = ChargingAttributes.ContentState(
                soc: soc,
                timeRemainingMins: timeRemainingMins,
                speedKw: speedKw,
                costRm: costRm,
                isDarkMode: isDarkMode
            )
            
            do {
                let activity = try Activity<ChargingAttributes>.request(
                    attributes: attributes,
                    content: .init(state: initialContentState, staleDate: nil),
                    pushType: nil
                )
                self.currentActivity = activity
                print("Requested Live Activity: \(activity.id)")
            } catch {
                print("Error requesting Live Activity: \(error.localizedDescription)")
            }
        }
    }
    
    func updateLiveActivity(soc: Double, timeRemainingMins: Int, speedKw: Double, costRm: Double, isDarkMode: Bool) {
        if #available(iOS 16.1, *) {
            guard let activity = currentActivity as? Activity<ChargingAttributes> else {
                // Try to find any active activity
                if let activeActivity = Activity<ChargingAttributes>.activities.first {
                    self.currentActivity = activeActivity
                    updateLiveActivity(soc: soc, timeRemainingMins: timeRemainingMins, speedKw: speedKw, costRm: costRm, isDarkMode: isDarkMode)
                }
                return
            }
            
            let updatedState = ChargingAttributes.ContentState(
                soc: soc,
                timeRemainingMins: timeRemainingMins,
                speedKw: speedKw,
                costRm: costRm,
                isDarkMode: isDarkMode
            )
            
            Task {
                await activity.update(.init(state: updatedState, staleDate: nil))
                print("Updated Live Activity: \(activity.id)")
            }
        }
    }
    
    func stopLiveActivity() {
        if #available(iOS 16.1, *) {
            let activities = Activity<ChargingAttributes>.activities
            for activity in activities {
                Task {
                    await activity.end(nil, dismissalPolicy: .immediate)
                }
            }
            self.currentActivity = nil
            print("Stopped all charging Live Activities.")
        }
    }
}
