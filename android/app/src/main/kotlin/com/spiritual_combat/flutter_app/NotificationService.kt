package com.spiritual_combat.flutter_app

import android.app.*
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import java.util.*

class NotificationService : Service() {

    companion object {
        const val TAG = "NotificationService"
        const val CHANNEL_ID = "spiritual_combat_quotes"
        const val CHANNEL_NAME = "Daily Spiritual Quotes"
        const val NOTIFICATION_ID = 1001
        
        const val ACTION_SCHEDULE = "com.spiritual_combat.flutter_app.ACTION_SCHEDULE"
        const val ACTION_SHOW_QUOTE = "com.spiritual_combat.flutter_app.ACTION_SHOW_QUOTE"
        const val ACTION_CANCEL = "com.spiritual_combat.flutter_app.ACTION_CANCEL"
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "NotificationService created")
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "onStartCommand called with action: ${intent?.action}")
        
        when (intent?.action) {
            ACTION_SCHEDULE -> {
                Log.d(TAG, "Scheduling daily notifications")
                scheduleDailyNotification()
            }
            ACTION_SHOW_QUOTE -> {
                Log.d(TAG, "Showing quote notification")
                val quoteText = intent.getStringExtra("quote_text")
                val quoteCategory = intent.getStringExtra("quote_category")
                showQuoteNotification(quoteText, quoteCategory)
            }
            ACTION_CANCEL -> {
                Log.d(TAG, "Canceling notifications")
                cancelScheduledNotifications()
            }
            else -> {
                Log.d(TAG, "Unknown action or null intent")
            }
        }

        return START_STICKY
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val importance = NotificationManager.IMPORTANCE_HIGH
            val channel = NotificationChannel(CHANNEL_ID, CHANNEL_NAME, importance).apply {
                description = "Daily spiritual quotes from Combate Espiritual"
                enableLights(true)
                enableVibration(true)
                setShowBadge(true)
            }

            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
            Log.d(TAG, "Notification channel created")
        }
    }

    private fun scheduleDailyNotification() {
        try {
            val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val intent = Intent(this, NotificationReceiver::class.java).apply {
                action = NotificationReceiver.ACTION_SHOW_QUOTE
            }
            
            val pendingIntent = PendingIntent.getBroadcast(
                this,
                0,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            // Get notification time from SharedPreferences (default 9:00 AM)
            val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            val hour = prefs.getInt("flutter.notification_hour", 9)
            val minute = prefs.getInt("flutter.notification_minute", 0)

            // Schedule for next occurrence
            val calendar = Calendar.getInstance().apply {
                timeInMillis = System.currentTimeMillis()
                set(Calendar.HOUR_OF_DAY, hour)
                set(Calendar.MINUTE, minute)
                set(Calendar.SECOND, 0)
                
                // If time has passed today, schedule for tomorrow
                if (timeInMillis <= System.currentTimeMillis()) {
                    add(Calendar.DAY_OF_YEAR, 1)
                }
            }

            // Use setExactAndAllowWhileIdle for precise timing
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                alarmManager.setExactAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    calendar.timeInMillis,
                    pendingIntent
                )
            } else {
                alarmManager.setExact(
                    AlarmManager.RTC_WAKEUP,
                    calendar.timeInMillis,
                    pendingIntent
                )
            }

            Log.d(TAG, "Notification scheduled for: ${calendar.time}")
        } catch (e: Exception) {
            Log.e(TAG, "Error scheduling notification: ${e.message}", e)
        }
    }

    private fun showQuoteNotification(quoteText: String?, quoteCategory: String?) {
        try {
            // If no quote provided, use default
            val quote = quoteText ?: getDefaultQuote()
            val category = quoteCategory ?: "spiritual"

            val notificationIntent = Intent(this, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            }

            val pendingIntent = PendingIntent.getActivity(
                this,
                0,
                notificationIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            val notification = NotificationCompat.Builder(this, CHANNEL_ID)
                .setSmallIcon(android.R.drawable.ic_dialog_info)
                .setContentTitle("Combate Espiritual")
                .setContentText(quote)
                .setStyle(NotificationCompat.BigTextStyle().bigText(quote))
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setCategory(NotificationCompat.CATEGORY_MESSAGE)
                .setAutoCancel(true)
                .setContentIntent(pendingIntent)
                .setVibrate(longArrayOf(0, 500, 250, 500))
                .build()

            val notificationManager = NotificationManagerCompat.from(this)
            notificationManager.notify(NOTIFICATION_ID, notification)
            
            Log.d(TAG, "Notification displayed successfully")

            // Reschedule for tomorrow
            scheduleDailyNotification()
        } catch (e: Exception) {
            Log.e(TAG, "Error showing notification: ${e.message}", e)
        }
    }

    private fun cancelScheduledNotifications() {
        try {
            val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val intent = Intent(this, NotificationReceiver::class.java)
            val pendingIntent = PendingIntent.getBroadcast(
                this,
                0,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            
            alarmManager.cancel(pendingIntent)
            pendingIntent.cancel()
            
            Log.d(TAG, "Scheduled notifications canceled")
        } catch (e: Exception) {
            Log.e(TAG, "Error canceling notifications: ${e.message}", e)
        }
    }

    private fun getDefaultQuote(): String {
        val quotes = listOf(
            "No hay victoria sin combate, ni combate sin enemigo.",
            "La desconfianza de ti mismo es el fundamento de la vida espiritual.",
            "Confía plenamente en Dios y desconfía totalmente de ti mismo.",
            "La oración es el arma más poderosa contra el enemigo espiritual.",
            "La humildad es el escudo que nos protege de todos los ataques del enemigo."
        )
        return quotes.random()
    }

    override fun onDestroy() {
        super.onDestroy()
        Log.d(TAG, "NotificationService destroyed")
    }
}
