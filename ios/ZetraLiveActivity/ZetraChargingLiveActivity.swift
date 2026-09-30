import ActivityKit
import WidgetKit
import SwiftUI

@available(iOS 16.1, *)
public struct ZetraChargingLiveActivity: Widget {
    public init() {}

    public var body: some WidgetConfiguration {
        ActivityConfiguration(for: ChargingAttributes.self) { context in
            // Lock Screen / Notification Banner UI
            ZetraLockScreenView(state: context.state)
                .activityBackgroundTint(Color.black.opacity(0.85))
                .activitySystemActionForegroundColor(Color.white)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded Leading
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .stroke(Color.white.opacity(0.15), lineWidth: 3)
                                .frame(width: 38, height: 38)
                            Circle()
                                .trim(from: 0, to: CGFloat(context.state.soc))
                                .stroke(
                                    LinearGradient(
                                        colors: [Color(red: 0.0, green: 0.9, blue: 1.0), Color(red: 0.0, green: 1.0, blue: 0.4)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    style: StrokeStyle(lineWidth: 3, lineCap: .round)
                                )
                                .rotationEffect(.degrees(-90))
                                .frame(width: 38, height: 38)

                            Image(systemName: "bolt.fill")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(red: 0.0, green: 1.0, blue: 0.4))
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(Int(context.state.soc * 100))%")
                                .font(.system(size: 18, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                            Text("BATTERY")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                    .padding(.leading, 4)
                }

                // Expanded Trailing
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(String(format: "RM %.2f", context.state.costRm))
                            .font(.system(size: 16, weight: .heavy, design: .rounded))
                            .foregroundColor(Color(red: 0.0, green: 0.9, blue: 1.0))
                        Text("\(context.state.timeRemainingMins)m left")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.trailing, 4)
                }

                // Expanded Center
                DynamicIslandExpandedRegion(.center) {
                    HStack(spacing: 4) {
                        Image(systemName: "speedometer")
                            .font(.system(size: 12))
                            .foregroundColor(Color(red: 0.0, green: 1.0, blue: 0.4))
                        Text(String(format: "%.1f kW", context.state.speedKw))
                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.white.opacity(0.08))
                    .cornerRadius(12)
                }

                // Expanded Bottom
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(spacing: 8) {
                        // Progress bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.white.opacity(0.15))
                                    .frame(height: 6)

                                RoundedRectangle(cornerRadius: 3)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(red: 0.0, green: 0.9, blue: 1.0), Color(red: 0.0, green: 1.0, blue: 0.4)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: max(0, geometry.size.width * CGFloat(context.state.soc)), height: 6)
                            }
                        }
                        .frame(height: 6)

                        // Action Link (Stop Charging)
                        HStack {
                            Text("⚡ ZETRA SMART CHARGE")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white.opacity(0.5))

                            Spacer()

                            Link(destination: URL(string: "zetra://stop-charging")!) {
                                HStack(spacing: 4) {
                                    Image(systemName: "stop.fill")
                                        .font(.system(size: 9))
                                    Text("Stop")
                                        .font(.system(size: 11, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 5)
                                .background(Color.red.opacity(0.8))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal, 4)
                    .padding(.top, 4)
                }
            } compactLeading: {
                HStack(spacing: 3) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(red: 0.0, green: 1.0, blue: 0.4))
                    Text("\(Int(context.state.soc * 100))%")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
            } compactTrailing: {
                Text(String(format: "%.0f kW", context.state.speedKw))
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(Color(red: 0.0, green: 0.9, blue: 1.0))
            } minimal: {
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 2)
                    Circle()
                        .trim(from: 0, to: CGFloat(context.state.soc))
                        .stroke(Color(red: 0.0, green: 1.0, blue: 0.4), lineWidth: 2)
                        .rotationEffect(.degrees(-90))
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 9))
                        .foregroundColor(Color(red: 0.0, green: 1.0, blue: 0.4))
                }
            }
        }
    }
}

// ────────────────────────────────────────────────────────────────────────────
// Lock Screen / Notification Banner View
// ────────────────────────────────────────────────────────────────────────────
@available(iOS 16.1, *)
struct ZetraLockScreenView: View {
    let state: ChargingAttributes.ContentState

    var body: some View {
        VStack(spacing: 12) {
            // Header: Branding + Speed Badge
            HStack {
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color(red: 0.0, green: 1.0, blue: 0.4))
                        .frame(width: 8, height: 8)
                        .shadow(color: Color(red: 0.0, green: 1.0, blue: 0.4).opacity(0.8), radius: 4)

                    Text("ZETRA EV CHARGING")
                        .font(.system(size: 11, weight: .black, design: .rounded))
                        .foregroundColor(.white.opacity(0.85))
                        .tracking(1)
                }

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "bolt.circle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 0.0, green: 0.9, blue: 1.0))
                    Text(String(format: "%.1f kW", state.speedKw))
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(Color.white.opacity(0.12))
                .cornerRadius(10)
            }

            // Main Info: Gauge + Metrics
            HStack(spacing: 16) {
                // Circular Gauge
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.12), lineWidth: 7)
                        .frame(width: 68, height: 68)

                    Circle()
                        .trim(from: 0, to: CGFloat(state.soc))
                        .stroke(
                            LinearGradient(
                                colors: [Color(red: 0.0, green: 0.9, blue: 1.0), Color(red: 0.0, green: 1.0, blue: 0.4)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 7, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .frame(width: 68, height: 68)
                        .shadow(color: Color(red: 0.0, green: 1.0, blue: 0.4).opacity(0.4), radius: 6)

                    VStack(spacing: 0) {
                        Text("\(Int(state.soc * 100))%")
                            .font(.system(size: 17, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        Text("SOC")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }

                // Middle Info
                VStack(alignment: .leading, spacing: 4) {
                    Text("ACTIVE CHARGING")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(red: 0.0, green: 1.0, blue: 0.4))

                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.6))
                        Text("\(state.timeRemainingMins) mins remaining")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.85))
                    }

                    Text(String(format: "Accrued: RM %.2f", state.costRm))
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.0, green: 0.9, blue: 1.0))
                }

                Spacer()

                // Stop Button
                Link(destination: URL(string: "zetra://stop-charging")!) {
                    VStack(spacing: 3) {
                        Image(systemName: "stop.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                        Text("Stop")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .frame(width: 54, height: 54)
                    .background(
                        LinearGradient(
                            colors: [Color.red.opacity(0.85), Color.red.opacity(0.65)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                }
            }

            // Horizontal Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.12))
                        .frame(height: 6)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                colors: [Color(red: 0.0, green: 0.9, blue: 1.0), Color(red: 0.0, green: 1.0, blue: 0.4)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(0, geometry.size.width * CGFloat(state.soc)), height: 6)
                }
            }
            .frame(height: 6)
        }
        .padding(14)
        .background(
            Color(red: 0.07, green: 0.09, blue: 0.13)
        )
    }
}
