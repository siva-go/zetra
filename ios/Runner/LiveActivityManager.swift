import Foundation
import ActivityKit
import Flutter

class LiveActivityManager {
    static let shared = LiveActivityManager()
    
    private init() {}
    
    private var currentActivity: Any? = nil
    
    func startLiveActivity(soc: Double, timeRemainingMins: Int, speedKw: Double, costRm: Double, isDarkMode: Bool) {
        if #available(iOS 16.1, *) {
            guard ActivityAuthorizationInfo().areActivitiesEnabled else {
                print("[ZETRA ActivityKit] Live Activities are disabled in system settings.")
                return
            }
            
            // End any previously active activities before starting a new one
            stopLiveActivity()
            
            let attributes = ChargingAttributes(sessionName: "ZETRA Active Charging")
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
                print("[ZETRA ActivityKit] Live Activity started successfully with id: \(activity.id)")
            } catch {
                print("[ZETRA ActivityKit] Failed to start Live Activity: \(error.localizedDescription)")
            }
        }
    }
    
    func updateLiveActivity(soc: Double, timeRemainingMins: Int, speedKw: Double, costRm: Double, isDarkMode: Bool) {
        if #available(iOS 16.1, *) {
            guard let activity = currentActivity as? Activity<ChargingAttributes> else {
                // If current reference was lost, attempt to find existing active activity
                if let activeActivity = Activity<ChargingAttributes>.activities.first {
                    self.currentActivity = activeActivity
                    updateLiveActivity(
                        soc: soc,
                        timeRemainingMins: timeRemainingMins,
                        speedKw: speedKw,
                        costRm: costRm,
                        isDarkMode: isDarkMode
                    )
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
            print("[ZETRA ActivityKit] Stopped all active charging Live Activities.")
        }
    }
}
