import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyA4mrbRfQzivCzDhsihQ_z4zMUjx2Kra0A")
    GeneratedPluginRegistrant.register(with: self)
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let liveActivityChannel = FlutterMethodChannel(name: "app.zetraev.com/live_activity",
                                              binaryMessenger: controller.binaryMessenger)
    
    liveActivityChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      
      switch call.method {
      case "startLiveActivity":
          if #available(iOS 16.1, *) {
              guard let args = call.arguments as? [String: Any],
                    let soc = args["soc"] as? Double,
                    let timeRemainingMins = args["timeRemainingMins"] as? Int,
                    let speedKw = args["speedKw"] as? Double,
                    let costRm = args["costRm"] as? Double else {
                  result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing arguments", details: nil))
                  return
              }
              let isDarkMode = args["isDarkMode"] as? Bool ?? true
              LiveActivityManager.shared.startLiveActivity(soc: soc, timeRemainingMins: timeRemainingMins, speedKw: speedKw, costRm: costRm, isDarkMode: isDarkMode)
          }
          result(nil)
          
      case "updateLiveActivity":
          if #available(iOS 16.1, *) {
              guard let args = call.arguments as? [String: Any],
                    let soc = args["soc"] as? Double,
                    let timeRemainingMins = args["timeRemainingMins"] as? Int,
                    let speedKw = args["speedKw"] as? Double,
                    let costRm = args["costRm"] as? Double else {
                  result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing arguments", details: nil))
                  return
              }
              let isDarkMode = args["isDarkMode"] as? Bool ?? true
              LiveActivityManager.shared.updateLiveActivity(soc: soc, timeRemainingMins: timeRemainingMins, speedKw: speedKw, costRm: costRm, isDarkMode: isDarkMode)
          }
          result(nil)
          
      case "stopLiveActivity":
          if #available(iOS 16.1, *) {
              LiveActivityManager.shared.stopLiveActivity()
          }
          result(nil)
          
      default:
          result(FlutterMethodNotImplemented)
      }
    })
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
