package app.zetraev.com

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "app.zetraev.com/live_activity"
    private val NOTIFICATION_ID = 2026
    private val CHANNEL_ID = "zetra_charging_channel"
    private var methodChannel: MethodChannel? = null

    private val stopReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            methodChannel?.invokeMethod("stopChargingFromNotification", null)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        
        // Register receiver for the "Stop" button click
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(stopReceiver, IntentFilter("app.zetraev.com.STOP_CHARGING"), Context.RECEIVER_NOT_EXPORTED)
        } else {
            registerReceiver(stopReceiver, IntentFilter("app.zetraev.com.STOP_CHARGING"))
        }

        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "startLiveActivity" -> {
                    val soc = call.argument<Double>("soc") ?: 0.0
                    val timeRemainingMins = call.argument<Int>("timeRemainingMins") ?: 0
                    val speedKw = call.argument<Double>("speedKw") ?: 0.0
                    val costRm = call.argument<Double>("costRm") ?: 0.0
                    showNotification(soc, timeRemainingMins, speedKw, costRm)
                    result.success(null)
                }
                "updateLiveActivity" -> {
                    val soc = call.argument<Double>("soc") ?: 0.0
                    val timeRemainingMins = call.argument<Int>("timeRemainingMins") ?: 0
                    val speedKw = call.argument<Double>("speedKw") ?: 0.0
                    val costRm = call.argument<Double>("costRm") ?: 0.0
                    showNotification(soc, timeRemainingMins, speedKw, costRm)
                    result.success(null)
                }
                "stopLiveActivity" -> {
                    dismissNotification()
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun showNotification(soc: Double, timeRemainingMins: Int, speedKw: Double, costRm: Double) {
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        
        // Create Channel if Android 8.0+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Active Charging Session",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Shows real-time EV charging status on the lock screen."
                setShowBadge(false)
            }
            notificationManager.createNotificationChannel(channel)
        }

        // Remote Views Setup
        val remoteViews = RemoteViews(packageName, R.layout.layout_charging_notification).apply {
            setTextViewText(R.id.txt_soc_percentage, "${(soc * 100).toInt()}")
            setTextViewText(R.id.txt_time_remaining, "🕒 $timeRemainingMins mins left")
            setTextViewText(R.id.txt_rate_value, "$speedKw kW")
            setTextViewText(R.id.txt_cost_value, String.format("RM %.2f", costRm))
            setProgressBar(R.id.soc_circular_progress, 100, (soc * 100).toInt(), false)
            setProgressBar(R.id.charging_horizontal_progress, 100, (soc * 100).toInt(), false)
        }

        // Stop Action Intent
        val stopIntent = Intent("app.zetraev.com.STOP_CHARGING")
        val flag = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }
        val pendingStopIntent = PendingIntent.getBroadcast(this, 0, stopIntent, flag)
        remoteViews.setOnClickPendingIntent(R.id.btn_stop, pendingStopIntent)

        // Content Intent (Tapping the notification opens the app)
        val contentIntent = packageManager.getLaunchIntentForPackage(packageName)
        val pendingContentIntent = PendingIntent.getActivity(this, 0, contentIntent, flag)

        val builder = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setStyle(NotificationCompat.DecoratedCustomViewStyle())
            .setCustomContentView(remoteViews)
            .setCustomBigContentView(remoteViews)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setContentIntent(pendingContentIntent)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)

        notificationManager.notify(NOTIFICATION_ID, builder.build())
    }

    private fun dismissNotification() {
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.cancel(NOTIFICATION_ID)
    }

    override fun onDestroy() {
        try {
            unregisterReceiver(stopReceiver)
        } catch (e: Exception) {
            // Ignore
        }
        super.onDestroy()
    }
}
