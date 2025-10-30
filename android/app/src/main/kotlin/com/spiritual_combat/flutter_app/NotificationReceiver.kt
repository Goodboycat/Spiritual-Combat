package com.spiritual_combat.flutter_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class NotificationReceiver : BroadcastReceiver() {
    
    companion object {
        const val TAG = "NotificationReceiver"
        const val ACTION_SHOW_QUOTE = "com.spiritual_combat.flutter_app.ACTION_SHOW_QUOTE"
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        if (context == null || intent == null) {
            Log.e(TAG, "Context or Intent is null")
            return
        }

        Log.d(TAG, "Received broadcast: ${intent.action}")

        when (intent.action) {
            Intent.ACTION_BOOT_COMPLETED -> {
                Log.d(TAG, "Device booted, scheduling notifications")
                scheduleNotifications(context)
            }
            "android.intent.action.QUICKBOOT_POWERON" -> {
                Log.d(TAG, "Quick boot detected, scheduling notifications")
                scheduleNotifications(context)
            }
            ACTION_SHOW_QUOTE -> {
                Log.d(TAG, "Show quote action triggered")
                showQuoteNotification(context, intent)
            }
            else -> {
                Log.d(TAG, "Unknown action: ${intent.action}")
            }
        }
    }

    private fun scheduleNotifications(context: Context) {
        try {
            val serviceIntent = Intent(context, NotificationService::class.java)
            serviceIntent.action = NotificationService.ACTION_SCHEDULE
            context.startService(serviceIntent)
            Log.d(TAG, "Notification service started for scheduling")
        } catch (e: Exception) {
            Log.e(TAG, "Error scheduling notifications: ${e.message}", e)
        }
    }

    private fun showQuoteNotification(context: Context, intent: Intent) {
        try {
            val quoteText = intent.getStringExtra("quote_text")
            val quoteCategory = intent.getStringExtra("quote_category")
            
            if (quoteText.isNullOrEmpty()) {
                Log.w(TAG, "Quote text is empty, fetching from service")
                val serviceIntent = Intent(context, NotificationService::class.java)
                serviceIntent.action = NotificationService.ACTION_SHOW_QUOTE
                context.startService(serviceIntent)
            } else {
                Log.d(TAG, "Showing notification with quote: $quoteText")
                val serviceIntent = Intent(context, NotificationService::class.java)
                serviceIntent.action = NotificationService.ACTION_SHOW_QUOTE
                serviceIntent.putExtra("quote_text", quoteText)
                serviceIntent.putExtra("quote_category", quoteCategory)
                context.startService(serviceIntent)
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error showing quote notification: ${e.message}", e)
        }
    }
}
